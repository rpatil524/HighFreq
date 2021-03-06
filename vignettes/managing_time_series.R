## ----eval=FALSE----------------------------------------------------------
#  # load HighFreq
#  library(HighFreq)
#  # create local copy of SPY TAQ data
#  ta_q <- HighFreq::SPY_TAQ
#  # convert timezone of index to New_York
#  index(ta_q) <- lubridate::with_tz(time=index(ta_q), tzone=tzone)
#  # subset data to NYSE trading hours
#  ta_q <- ta_q['T09:30:00/T16:00:00', ]
#  # remove duplicate time stamps using duplicated()
#  ta_q <- ta_q[!duplicated(index(ta_q)), ]
#  # scrub quotes with suspect bid-offer spreads
#  bid_offer <- ta_q[, "Ask.Price"] - ta_q[, "Bid.Price"]
#  sus_pect <- which_extreme(bid_offer, look_back=look_back, vol_mult=vol_mult)
#  # remove suspect values
#  ta_q <- ta_q[!sus_pect]
#  # calculate mid prices
#  mid_prices <- 0.5 * (ta_q[, "Bid.Price"] + ta_q[, "Ask.Price"])
#  # replace whole rows containing suspect price jumps with NA, and perform locf()
#  ta_q[which_jumps(mid_prices, look_back=31, vol_mult=1.0), ] <- NA
#  ta_q <- xts:::na.locf.xts(ta_q)

## ----eval=FALSE----------------------------------------------------------
#  # scrub and aggregate a single day of SPY TAQ data to OHLC
#  oh_lc <- HighFreq::scrub_agg(ta_q=HighFreq::SPY_TAQ)
#  chart_Series(oh_lc, name=sym_bol)

## ----eval=FALSE----------------------------------------------------------
#  # load HighFreq
#  library(HighFreq)
#  # set data directories
#  data_dir <- "C:/Develop/data/hfreq/src/"
#  output_dir <- "C:/Develop/data/hfreq/scrub/"
#  sym_bol <- "SPY"
#  # aggregate SPY TAQ data to 15-min OHLC bar data, and save the data to a file
#  save_scrub_agg(sym_bol=sym_bol, data_dir=data_dir, output_dir=output_dir, period="15 min")

## ----eval=FALSE----------------------------------------------------------
#  # load HighFreq
#  library(HighFreq)
#  sym_bols <- c("SPY", "TLT", "VXX")
#  # aggregate TAQ data to 15-min OHLC bar data, and save the data to a file
#  sapply(sym_bols, save_scrub_agg,
#         data_dir=data_dir, output_dir=output_dir, period="15 min")

## ----eval=FALSE----------------------------------------------------------
#  # load HighFreq
#  library(HighFreq)
#  # set data directories
#  data_dir <- "C:/Develop/data/hfreq/src/"
#  output_dir <- "C:/Develop/data/hfreq/scrub/"
#  sym_bol <- "SPY"
#  # load a single day of TAQ data
#  file_name <- paste0(sym_bol, "/2014.05.02.", sym_bol, ".RData")
#  sym_bol <- load(file.path(data_dir, paste0(sym_bol, "/2014.05.02.", sym_bol, ".RData")))
#  # scrub a single day of TAQ data, without aggregating it to OHLC
#  ta_q <- scrub_taq(ta_q=get(sym_bol))
#  save(list=sym_bol, file=file.path(output_dir, file_name))

