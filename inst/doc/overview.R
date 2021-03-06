## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(SBICgraph)
library(network) # for visualization 

# to reset par
resetPar <- function() {
    dev.new()
    op <- par(no.readonly = TRUE)
    dev.off()
    op
}

## ----simulate_data------------------------------------------------------------
p <- 200
m1 <- 100
m2 <- 30
d <- simulate(n=100, p=p, m1=m1, m2=m2)
data<- d$data
real<- d$realnetwork
priori<- d$priornetwork


## ----visualize_networks-------------------------------------------------------
prior_net <- network(priori)
real_net <- network(real)
par(mfrow = c(1,2))
plot(prior_net, main = "Prior network")
plot(real_net, main = "Real network")
par(resetPar())

## ----examining_networks-------------------------------------------------------
sum(priori[lower.tri(priori)])
sum(priori[lower.tri(priori)])/(p*(p-1)/2)
sum(real[lower.tri(real)])
sum(real[lower.tri(real)])/(p*(p-1)/2)

## ----fit_models---------------------------------------------------------------
lambda<- exp(seq(-10,10, length=30))
# calculating the error rate from the number of edges in the true graph and the number of discordant pairs 
r1 <- m2/m1
r2 <-m2/(p*(p-1)/2-m1)
r <- (r1+r2)/2
model<- sggm(data = data, lambda = lambda, M=priori, prob = r)

## -----------------------------------------------------------------------------
print("Comparing estimated model with the real network")
comparison(real = real, estimate = model$networkhat)
print("Comparing the prior network with the real network")
comparison(real = real, estimate = priori)

## -----------------------------------------------------------------------------
estimated_net <- network(model$networkhat)
par(mfrow = c(1,3))
plot(prior_net, main = "Prior Network")
plot(real_net, main = "Real Network")
plot(estimated_net, main = "Estimated Network")
par(resetPar())

## -----------------------------------------------------------------------------
length(model$candidate)

