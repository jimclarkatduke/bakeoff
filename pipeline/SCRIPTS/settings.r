##########################################################################################
# PATHS, ASSIGNMENTS, ETC.
##########################################################################################

dataN<-c(150,300,600)			# data sizes
REPs<-100						# no. of prediction replicates

Sets <- c("birds","butterfly","plant","trees","vegetation")
betaInds<-c("sim", "nest", "sor")


# basic working directories
##########################################################################################
WD <- paste(pth,"bakeoff/pipeline/",sep="")

# data directory
DD <- paste(WD,"DATA/",sep="")

# model fitting scripts directory
MD <- paste(WD,"MODELS/",sep="")

# model fits directory
FD <- paste(WD,"FITS/",sep="")

# model fits directory 2
FD2 <- paste(WD,"FITS2/",sep="")

# prediction scripts directory
PD <- paste(WD,"PREDICT/",sep="")

# predictions directory
PD2 <- paste(WD,"PREDICTIONS/",sep="")

# scripts directory for prev., rich, co-occ, etc. calculations
RD <- paste(WD,"RESULTS/",sep="")

# predictions  directory for prev., rich, co-occ, etc. calculations  (desktops)
RD2 <- paste(WD,"RESULTS2/",sep="")

# final results directory
RDfinal <- paste(WD,"RESULTS_final/",sep="")

DIRS<-list(WD,DD,MD,FD,PD,PD2,RD,RD2,RDfinal)

# read data
##########################################################################################
readdata<-paste(WD,"SCRIPTS/read.data.r",sep="")


# folder for the scripts for calculating occ probs, sp rich, beta indices
##########################################################################################
modpredsFolder<-paste(WD,"SCRIPTS/modify_preds",sep="")

# save objects
##########################################################################################
saveobjs<-c("sz","d","set_no","REPs","SETT","readdata","modpredsFolder","modpreds","dataN",
			"saveobjs","crs","Sets","betaInds",
			"pth","WD","DD","MD","FD","PD","PD2","RD","RD2","RDfinal","MCMC2")
saveobjs2<-c(saveobjs,"PMs","PMS","opts","ENS","PRV")

# models
##########################################################################################
mod_names <- list("GAM1","GAM2",
				"GLM1",
				"GLM2","GLM3",
				"GLM6",
				"MRTS1",
				"GNN1",
				"RF1",
				"BRT1",
				"SVM1",
				"MARS1","MARS2",
				"GJAM1",
				"SAM1",
				"MISTN1",
				"GLM7","BORAL1",
				"BC1","BC2",
				"GLM4","GLM5",
				"HMSC1","HMSC2","HMSC3")
mod_names2 <- c(rep("GAM",2),
				rep("GLM",4),
				"MRTS",
				"GNN",
				"RF",
				"BRT",
				"SVM",
				rep("MARS",2),
				"GJAM",
				"SAM",
				"MISTN",
				"GLM",
				"BORAL",
				rep("BC",2),
				rep("GLM",2),
				rep("HMSC",3))
mod_names3 <- c("GAM","GAMspat1",
				"GLM1",
				"GLMPQL1","GLMPQLspat1",
				"MVABUND1",
				"MRTS1",
				"GNN1",
				"RF1",
				"BRT1",
				"SVM1",
				"MARS1","MARS2",
				"GJAM1",
				"SAM1",
				"MISTN1",
				"BORAL1","BORAL2",
				"BC1","BC2",
				"hmsc1","hmsc2",
				"hmsc1","hmsc2","hmsc3")
cbind(mod_names,mod_names2,mod_names3)
nmodels<-length(mod_names)
models <- 1:nmodels
nfrmwrks<-length(unique(mod_names2))

# predictions
##########################################################################################
pred_names	<-	list("gam1_PAs_","gam_spat1_PAs_",
				"glm1_PAs_",
				"glmmPQL1_PAs_","glmmPQLspat1_PAs_",
				"manyglm1_PAs_",
				"mrt1_PAs_",
				"gnn1_PAs_",
				"rf1_PAs_",
				"brt1_PAs_",
				"svm1_PAs_",
				"mars1_PAs_","mars2_PAs_",
				"gjam1_PAs_",
				"sam1_PAs_",
				"mstnt1_PAs_",
				"boral1_PAs_","boral2_PAs_",
				"bc1_PAs_","bc2_PAs_",
				"ss_hmsc1_PAs_","ss_hmsc2_PAs_",
				"hmsc1_PAs_","hmsc2_PAs_","hmsc3_PAs_")
names(pred_names)<-mod_names

print(cbind(mod_names,mod_names2,mod_names3,pred_names))

##########################################################################################

if (length(mod_names)!=length(pred_names)) {
	stop("The vector of rediction objects and the vector of prediction names are of different size")
	}

# MODEL FEATURES
##########################################################################################
feats<-read.csv2(paste(DD,"feats.csv",sep=""),header=T)
rownames(feats)<-feats[,1]
feats<-feats[unlist(mod_names),]

PMnames		<-	c("accuracy1","discrimination1","sharpness1","calibration1",
				"accuracy2site","accuracy3beta1","accuracy3beta2","accuracy3beta3",
				"discrimination2site","discrimination3beta1","discrimination3beta2","discrimination3beta3",
				"sharpness2site","sharpness3beta1","sharpness3beta2","sharpness3beta3",
				"calibration2site","calibration3beta1","calibration3beta2","calibration3beta3")
minTomaxBest <- c("accuracy1","sharpness1","calibration1",
				"accuracy2site","accuracy3beta1","accuracy3beta2","accuracy3beta3",
				"sharpness2site","sharpness3beta1","sharpness3beta2","sharpness3beta3",
				"calibration2site","calibration3beta1","calibration3beta2","calibration3beta3")

minIsBest1<-matrix(0,nrow=length(PMnames))
rownames(minIsBest1)<-PMnames
minIsBest1[minTomaxBest,]<-1
minIsBest1<-cbind(rownames(minIsBest1),minIsBest1)
if (!file.exists(paste(RDfinal,"minIsBest1.csv",sep=""))) {
	write.table(minIsBest1,file=paste(RDfinal,"minIsBest1.csv",sep=""),sep=",",row.names=F,col.names=F)					
}
##########################################################################################
