#!/usr/bin/Rscript
#
# This is an example R script that generates a single-page PDF summary.
#
# It requires two packages to be installed. Do this from the R command line:
# install.packages('gplots','zoo')
#
# Some sample data and example out is provided:
#
# data/all_services.csv.sample        - sample CSV data for a years worth of elec, gas, and water
# data/all_services.sample.pdf        - PDF analysis produced by this script for all_services.csv.sample
# data/elec_and_water_only.csv.sample - sample CSV data for a years worth of elec and water
# data/elec_and_water_only.sample.pdf - PDF analysis produced by this script for elec_and_water_only.csv.sample
#
# Usage:
#   ./full_analysis.R data_file.csv
#
# Output is written to a file called 'full_analysis.pdf' in the current directory
#
# data_file.csv has the collowing columns (with a header row):
#   invoice_month,measure,kwh,cubic_m,rate,amount
#
# NB: the script scan_all_bills.sh is an example of how to produce a suitable file
#

# data_file <-'data/all_services.csv.sample'
argv <- commandArgs(TRUE)
data_file <- argv[1]
output_file <- 'full_analysis.pdf'

cat("Analyzing SP Service billing data from:",data_file,"\n")
cat("Results are written to:",output_file,"\n\n")

# required libs
library(gplots)
library(zoo)

#reads: invoice_month,measure,kwh,cubic_m,rate,amount
bills <- read.csv(data_file)

# core data
charges <- subset(bills, subset=(measure == 'total_charges'), select = c(-measure,-kwh,-cubic_m,-rate))
electricity <- subset(bills, subset=(measure == 'electricity'), select = c(-measure,-cubic_m))
gas <- subset(bills, subset=(measure == 'gas'), select = c(-measure,-cubic_m))
water <- subset(bills, subset=(measure == 'water'), select = c(-measure,-kwh))

# moving averages over 3 months
ma_over <- 3

# summarise electricity usage
#
electricity.raw.kwh_by_month <- tapply(electricity$kwh, electricity$invoice_month, sum)
electricity.raw.amount_by_month <- tapply(electricity$amount, electricity$invoice_month, sum)

kwh <- zoo(
  as.vector(electricity.raw.kwh_by_month),
  as.Date(unlist(dimnames(electricity.raw.kwh_by_month)))
)
amount <- zoo(
  as.vector(electricity.raw.amount_by_month),
  as.Date(unlist(dimnames(electricity.raw.amount_by_month)))
)
meter <- merge(kwh,amount)
ma <- rollmean(meter, ma_over, align="center")
electricity.timeseries <- merge(meter,ma)

# summarise gas usage
#
gas.raw.kwh_by_month <- tapply(gas$kwh, gas$invoice_month, sum)
gas.raw.amount_by_month <- tapply(gas$amount, gas$invoice_month, sum)

kwh <- zoo(
  as.vector(gas.raw.kwh_by_month),
  as.Date(unlist(dimnames(gas.raw.kwh_by_month)))
)
amount <- zoo(
  as.vector(gas.raw.amount_by_month),
  as.Date(unlist(dimnames(gas.raw.amount_by_month)))
)
meter <- merge(kwh,amount)
ma <- rollmean(meter, ma_over, align="center")
gas.timeseries <- merge(meter,ma)


# summarise water usage
#
water.raw.cubic_m_by_month <- tapply(water$cubic_m, water$invoice_month, sum)
water.raw.amount_by_month <- tapply(water$amount, water$invoice_month, sum)

cubic_m <- zoo(
  as.vector(water.raw.cubic_m_by_month),
  as.Date(unlist(dimnames(water.raw.cubic_m_by_month)))
)
amount <- zoo(
  as.vector(water.raw.amount_by_month),
  as.Date(unlist(dimnames(water.raw.amount_by_month)))
)
meter <- merge(cubic_m,amount)
ma <- rollmean(meter, ma_over, align="center")
water.timeseries <- merge(meter,ma)

# summarise charges
#
charges.raw.amount_by_month <- tapply(charges$amount, charges$invoice_month, sum)

amount <- zoo(
  as.vector(charges.raw.amount_by_month),
  as.Date(unlist(dimnames(charges.raw.amount_by_month)))
)
ma <- rollmean(amount, ma_over, align="center")
charges.timeseries <- merge(amount,ma)

# combined timeseries
ts <- merge(charges.timeseries,gas.timeseries,electricity.timeseries,water.timeseries)


# begin output
pdf(output_file)

# split the page into regions for plotting
par(mfrow=c(3,2))

# print charge summary
charge_summary <- subset(ts, select=c(amount,amount.meter.electricity.timeseries,amount.meter.gas.timeseries,amount.meter.water.timeseries))
colnames(charge_summary) <- c('Total','Electricity','Gas','Water')
textplot(
  capture.output(summary(as.matrix(charge_summary))),
  valign="top", halign="center", mar=c(4, 1, 4, 1) + 0.1
)
title("Total Charges SGD$")

# plot charge summary
amount <- as.vector(charges.timeseries$amount)
bp <- barplot2(amount,
  main="Total Monthly Bill",
  names.arg=index(charges.timeseries),
  ylab="Invoice Amount (SGD$)")
lines(bp, as.vector(charges.timeseries$ma), lty="dashed", lwd=2)

# alternative plot elec usage summary - basic bar chart
# barplot(electricity.timeseries$kwh.meter,
#   main="Electricity Usage",
#   names.arg=index(electricity.timeseries),
#   ylab="kwh")

# plot elec usage summary - bar chart with moving average
kwh <- as.vector(electricity.timeseries$kwh.meter)
colors <- colorpanel(length(kwh),'red','yellow')
bp <- barplot2(kwh,
  main="Electricity Usage",
  names.arg=index(electricity.timeseries),
  col=colors,
  ylab="kwh")
lines(bp, as.vector(electricity.timeseries$kwh.ma), lty="dashed", lwd=2)
legend('bottomleft', inset=0.05, legend=c("3m MA"), lty=c("dashed"), bty='o', bg='white')

# plot elec charges summary - line chart with moving average
df <- subset(electricity.timeseries, select=c(amount.meter,amount.ma))
x <- index(electricity.timeseries)
plot(df, screens=1,
  lty=c("solid", "dashed"), lwd=c(1,2), col=c('red','black'),
  main="Electricity Charges", xlab='', ylab="SGD$",
  xaxt = 'n')
axis(1, x, x)
legend('bottomleft', legend=c("meter","3m MA"), lty=c("solid", "dashed"), col=c('red','black'), bty='n')

# plot gas summary
kwh <- as.vector(gas.timeseries$kwh.meter)
kwh[is.na(kwh)] <- 0 # in case no values
colors <- colorpanel(length(kwh),'#0014EB','#0077EB')
bp <- barplot2(kwh,
  main="Gas Usage",
  names.arg=index(gas.timeseries),
  col=colors,
  ylab="kwh")
lines(bp, as.vector(gas.timeseries$kwh.ma), lty="dashed", lwd=2)

# plot water summary
cubic_m <- as.vector(water.timeseries$cubic_m.meter)
colors <- colorpanel(length(cubic_m),'#00EBEB','#009D62')
bp <- barplot2(cubic_m,
  main="Water Usage",
  names.arg=index(water.timeseries),
  col=colors,
  ylab="m^3")
lines(bp, as.vector(water.timeseries$cubic_m.ma), lty="dashed", lwd=2)


cat("Completed analyzing SP Service billing data from:",data_file,"\n")
cat("Results are written to:",output_file,"\n\n")

