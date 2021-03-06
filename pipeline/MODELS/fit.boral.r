##########################################################################################
# BAYESIAN ORDINATIO AND REGRESSION ANALYSIS
##########################################################################################

require(boral)

##########################################################################################

Nburn1<-40000
Niter1<-50000
Nthin1<-100

mcmcControl1<-list(n.burnin=Nburn1,n.iteration=Niter1,n.thin=Nthin1,seed=7)
mcmcControl2<-mcmcControl1
if (sz==2) {
	if (d==1) {
		Nburn2<-15000
		Niter2<-20000
		Nthin2<-50
	}
	if (d==2 | d==4) {
		Nburn2<-40000
		Niter2<-50000
		Nthin2<-100
	}
	if (d==3) {
		Nburn2<-12000
		Niter2<-18000
		Nthin2<-60
	}
	if (d==5) {
		Nburn2<-7000
		Niter2<-11000
		Nthin2<-40
	}
	mcmcControl2<-list(n.burnin=Nburn2,n.iteration=Niter2,n.thin=Nthin2,seed=7)
}

if (MCMC2) {
	mcmcControl1<-list(n.burnin=(Nburn1*2),n.iteration=(Niter1*2),n.thin=(Nthin1*2),seed=7)
	mcmcControl2<-list(n.burnin=(Nburn2*2),n.iteration=(Niter2*2),n.thin=(Nthin2*2),seed=7)
}
	
##########################################################################################

for (j in 1:3) {

	if (j==1) { sT<-Sys.time() }
	dir.create(paste(FD,set_no,"/boralModel1","_d",j,"_sz",sz,sep="")); setwd(paste(FD,set_no,"/boralModel1","_d",j,"_sz",sz,sep=""))
	brl1	<-	boral(y=y_train[[j]], X=x_train[[j]][,-1], num.lv=0,
			  			family = "binomial", calc.ics = FALSE, 
			  			mcmc.control=mcmcControl, save.model = TRUE)
	setwd(WD)
	if (j==1) { 
		eT<-Sys.time()
		comTimes<-eT-sT
	}	
	
	if (MCMC2) {
		save(brl1, file=paste(FD,set_no,"/brl1_",j,"_",dataN[sz],"_MCMC2.RData",sep=""))
		if (j==1) {
		save(comTimes, file=paste(FD,set_no,"/comTimes_BORAL1_",dataN[sz],"_MCMC2.RData",sep=""))
		}
	} else {
		save(brl1, file=paste(FD,set_no,"/brl1_",j,"_",dataN[sz],".RData",sep=""))
		if (j==1) {
		save(comTimes, file=paste(FD,set_no,"/comTimes_BORAL1_",dataN[sz],".RData",sep=""))
		}
	}

	if (j==1) { sT<-Sys.time() }
	dir.create(paste(FD,set_no,"/boralModel2","_d",j,"_sz",sz,sep="")); setwd(paste(FD,set_no,"/boralModel2","_d",j,"_sz",sz,sep=""))
	brl2	<-	boral(y=y_train[[j]], X=x_train[[j]][,-1], num.lv=2, 
			  		family = "binomial", calc.ics = FALSE,
			  		mcmc.control=mcmcControl, save.model = TRUE)
	setwd(WD)

	if (j==1) { 
		eT<-Sys.time()
		comTimes<-eT-sT
		}
	if (MCMC2) {
		save(brl2, file=paste(FD,set_no,"/brl2_",j,"_",dataN[sz],"_MCMC2.RData",sep=""))
		if (j==1) {
		save(comTimes, file=paste(FD,set_no,"/comTimes_BORAL2_",dataN[sz],"_MCMC2.RData",sep=""))
		}
	} else {
		save(brl2, file=paste(FD,set_no,"/brl2_",j,"_",dataN[sz],".RData",sep=""))
		if (j==1) {
		save(comTimes, file=paste(FD,set_no,"/comTimes_BORAL2_",dataN[sz],".RData",sep=""))
		}
	}

}
