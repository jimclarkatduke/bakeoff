# GAMs FOR THE BAKEOFF DATA
##########################################################################################

require('mgcv')
require('nlme')


if (set_no=="birds" | set_no=="butterfly" | set_no=="plant") { 
	form <- as.formula(sp~s(V1, bs="cr")+s(V2, bs="cr")+s(V3, bs="cr")+s(V4, bs="cr")+s(V5, bs="cr"))
# 	form_spat <- as.formula(sp~s(V1, bs="cr")+s(V2, bs="cr")+s(V3, bs="cr")+s(V4, bs="cr")+s(V5, bs="cr")+s(Rand1,Rand2, bs="re"))
}
if (set_no=="trees") { 
	form <- as.formula(sp~s(V1, bs="cr")+s(V2, bs="cr")+s(V3, bs="cr"))
# 	form_spat <- as.formula(sp~s(V1, bs="cr")+s(V2, bs="cr")+s(V3, bs="cr")+s(Rand1,Rand2, bs="re"))
}
if (set_no=="vegetation") { 
	form <- as.formula(sp~s(V1, bs="cr")+s(V2, bs="cr")+s(V3, bs="cr")+s(V4, bs="cr"))
# 	form_spat <- as.formula(sp~s(V1, bs="cr")+s(V2, bs="cr")+s(V3, bs="cr")+s(V4, bs="cr")+s(Rand1,Rand2, bs="re"))
}

##########################################################################################

gams1 <- list()
gams_spat1<- list()


for (j in 1:3) {

	nsp <- length(DD_t[[j]])

	if (j==1) { sT<-Sys.time() }

	gams1	<-	foreach	(i=1:nsp, .packages='mgcv') %dopar% { tryCatch({gam(form, family=binomial(link="probit"), data=DD_t[[j]][[i]])},
						error=function(e){cat("ERROR :",conditionMessage(e), "\n")}) }

	if (j==1) {
		eT<-Sys.time()
		comTimes<-eT-sT
		}

	save(gams1, file=paste(FD,set_no,"/gams1_",j,"_",dataN[sz],".RData",sep=""))
	if (j==1) {
		save(comTimes, file=paste(FD,set_no,"/comTimes_GAM_",dataN[sz],".RData",sep=""))
		rm(comTimes)
	}

	if (j==1) { sT<-Sys.time() }
	
	gams_spat1	<-	foreach	(i=1:nsp, .packages='mgcv') %dopar% { tryCatch({gamm(form, correlation=corGaus(form=~Rand1+Rand2), family=binomial(link="probit"), data=DD_t[[j]][[i]]) },
							error=function(e){cat("ERROR :",conditionMessage(e), "\n")}) }
	
	if (j==1) {
		eT<-Sys.time()
		comTimes<-eT-sT
		}

	save(gams_spat1, file=paste(FD,set_no,"/gams_spat1_",j,"_",dataN[sz],".RData",sep=""))
	if (j==1) {
		save(comTimes, file=paste(FD,set_no,"/comTimes_GAMspat1_",dataN[sz],".RData",sep=""))
		rm(comTimes)
	}
	
	rm(gams1)
	rm(gams_spat1)

}
##########################################################################################

