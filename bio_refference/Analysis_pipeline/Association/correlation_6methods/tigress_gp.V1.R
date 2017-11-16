# This is the command line version of TIGRESS, to be used on Gene Pattern - DREAM5
#
# Anne-CLaire Haury and Jean-Philippe Vert, Feb 2012
#
# Reference:
# A.-C. Haury, F. Mordelet, P. Vera-Licona and J.-P. Vert. TIGRESS: Trustful Inference of Gene REgulation using Stability Selection. Technical report, 2012.
#

TIGRESSCmdLine <- function(args) {
	suppressMessages(.TIGRESSCmdLine(args))
}

.TIGRESSCmdLine <- function(args) {
	gotrequired<-FALSE
	expdata <- ''
	tflist <- NULL
	K <- -1
	alpha <- 0.2
	nstepsLARS <- 5
	nbootstrap <- 100
	normalizeexp <- TRUE
	scoring <- "area"
	allsteps <- FALSE
	verb <- FALSE
	usemulticore <- TRUE
    num <- 1	
	#args <- list(...)
	if (length(args)>=2) {
		for(i in seq(1,length(args),by=2)) {
			flag <- args[i]
			value <- args[i+1]
			if(value=='') {
				next
			}
	
			if(flag=='--data') {
				expdata <- as.character(value)
				gotrequired=TRUE
			} else if(flag=='--reg') {
				tflist <- as.character(value)
			}  else if(flag=='--cut') {
				K <- as.integer(value)
			}  else if(flag=='--alpha') {
				alpha <- as.double(value)
				if(alpha>1 | alpha<0){
					stop("alpha must be between 0 and 1")}
			}  else if(flag=='--nbootstrap') {
				nbootstrap <- as.integer(value)
			} else if(flag=='--nstepsLARS') {
				nstepsLARS <- as.integer(value)
			} else if(flag=='--norm') {
				normalizeexp <- as.logical(value)
            } else if(flag=='--num') {
                num <- as.integer(value)

			} else if(flag=='--scoring') {
				scoring <- as.character(value)
				if(scoring!="area" & scoring!="max"){
					cat("scoring must be one of area or max.\n",stderr())
					return(-1)
				}
#			} else if(flag=='--allsteps') {
#				allsteps <- as.logical(value)
			} else if(flag=='--verbose') {
				verb <- as.logical(value)
			} else if(flag=='--usemulticore') {
				usemulticore <- as.logical(value)
			} else {
				cat(paste("Unknown option:",flag,"\n",sep=""),stderr())
				return(-1)
			}
		}
	}
	
	# Return an error if we dont have the minimal set of arguments
	if(!gotrequired) {
		cat("Error: Expression data is required!\n",stderr())
		return(-1)
	}
	
	if(verb){
		cat("TIGRESS will run with the following parameters:\n")
		cat("data: ", expdata, "\n")
		cat("reg: ", tflist, "\n")
		cat("cut: ", K, "\n")
		cat("alpha: ", alpha, "\n")
		cat("nstepsLARS: ", nstepsLARS, "\n")
		cat("nbootstrap: ", nbootstrap, "\n")
		cat("norm: ", normalizeexp, "\n")
		cat("scoring: ", scoring, "\n")
		cat("allsteps: ", allsteps, "\n")
		cat("verbose: ", verb, "\n")
		cat("usemulticore: ", usemulticore, "\n")
        cat("target num: ", num, "\n")}

		
	# We divide the number of boostraps by 2 because tigress runs two models for each bootstrap
	nbootstrap<-floor(nbootstrap/2)

	
	# Generate output file name as required by GP-DREAM
	filename<-basename(expdata)
	fullname<-gsub("[.][^.]*$","",filename)
	outfile<-paste('./',fullname,'_TIGRESS_predictions.txt',sep='')
	if (verb)
		cat("Results will be printed in: ",outfile,"\n")

	
	# Run tigress
	itworked <- try(tigress(expdata , tflist , outfile, K , alpha, nstepsLARS , nbootstrap , normalizeexp , scoring , allsteps , verb, usemulticore,num))
	
	# Return 0 if it worked, -1 otherwise
	invisible(ifelse(class(itworked)=="try-error", -1, 0))
}




###########################################################
# Below the original tigress.r file
# Should be replaced by require(tigress) once we publish the package
###########################################################



# All needed for TIGRESS in a single file
# JP Vert, Feb 9, 2012

require(lars,quietly=TRUE)



#cat (num)
stabilityselection <- 
function(x,y,nbootstrap=100,nstepsLARS=20,alpha=0.2,scoring="area")
{
	# Stability selection in the spirit of Meinshausen&Buhlman
	# JP Vert, 14/9/2010
	
	# INPUT
	# x : the n*p design matrix
	# y : the n*1 variable to predict
	# nbootstrap: number of splits of samples in two sets (i.e., we will average over 2*boostrap realizations)
	# nstepsLARS: number of LARS steps
	# alpha : the alpha parameter for weight randomization in stability selection. Should be between 0 and 1.
	# scoring: how to score a feature. If "area" we compute the area under the stability curve, as proposed by Haury et al. If "max" we just compute the stability curve, as propose by Meinshausen and Buhlmann.
	
	# OUTPUT
	# The stability selection scoring curves, in a matrix where each row is a step (from 1 to nstepsLARS) and each column is a column. 
		
	n <- nrow(x)
	p <- ncol(x)
	halfsize <- as.integer(n/2)
	freq <- matrix(0,nstepsLARS,p)
	
	for (i in seq(nbootstrap)) {
		# Randomly reweight each variable
		xs <- t(t(x)*runif(p,alpha,1))
	
		# Ramdomly split the sample in two sets
                set.seed(5)
		perm <- sample(n)
		i1 <- perm[1:halfsize]
		i2 <- perm[(halfsize+1):n]
	
		# run LARS on each randomized, sample and check which variables are selected
		r <- lars(xs[i1,],y[i1],max.steps=nstepsLARS,normalize=FALSE,trace=FALSE,use.Gram=F)	
		freq<-freq + abs(sign(r$beta[2:(nstepsLARS+1),]))		
		r <- lars(xs[i2,],y[i2],max.steps=nstepsLARS,normalize=FALSE,trace=FALSE,use.Gram=F)
		freq<-freq + abs(sign(r$beta[2:(nstepsLARS+1),]))		
	}
		
	# normalize frequence in [0,1] to get the stability curves
	freq <- freq/(2*nbootstrap)

	# Compute normalized area under the stability curve
	if (scoring=="area")
		score <- apply(freq,2,cumsum)/seq(nstepsLARS)
	else
		score <- apply(freq, 2, cummax)
		
	invisible(score)
}








tigress <- 
function(expdata , tflist=NULL , outfile="prediction.txt" , K=-1 , alpha=0.2 , nstepsLARS=5 , nbootstrap=100 , normalizeexp=TRUE , scoring="area" , allsteps=FALSE , verb=FALSE , usemulticore=TRUE,num=1)
{
	# INPUT
	# expdata : either a matrix of expression, or the name of a file containing it. Each row is an experiment, each column a gene. The gene names are the column names (or are in the first row of the file)
	# tflist : the list of TF, or the name of a file containing them. The TF name should match the names in the gene list of the expression data file. If NULL, then all genes are considered TF.
	# output_filename : where we write prediction. If empty, do not write anything.
	# K : number of edges to return. K=0 means that all edges are returned. 
	# alpha : the alpha parameter for randomization in stability selection. Should be between 0 and 1.
	# nstepsLARS : number of LARS steps to perform in stability selection
	# nbootstrap : number of randomization to perform in stability selection
	# normalizeexp : a boolean indicating whether we should mean center and scale to unit variance the expression data for each gene.
	# scoring : method for scoring a feature in stability selection. If "area", the score is the area under the stability curve up to nstepsLARS steps, as proposed by Haury et al. If "max", the score is the maximum value of the stability curve, as proposed by Meinshausen and Bühlmann in the original paper.
	# allsteps: a boolean indicating whether we should output the solutions for all values of LARS steps up to nstepsLARS, or only for nstepsLARS. It does not cost more computation to compute all solutions.
	# verb : verbose mode. If TRUE, print messages about what we are doing, otherwise remain silent.
	#
	# OUTPUT
	# A dataframe (or list of dataframes if allsteps=TRUE) with the top K predicted edges. First column is the TF, second column the target gene, third column the score. If outfile is provided, the result is also written to the file OUTFILE (if allsteps=FALSE) or to several files OUTFILE1, OUTFILE1, ... (if allsteps=TRUE)
	
	# Check if we can run multicore
    cat (num,"\n")
	if (usemulticore) {
		require(multicore)
	}
	
	# If needed, load expression data
	if (is.character(expdata))
		expdata <- read.csv(expdata, header=F,row.names=1)
	    expdata<-t(expdata)
	# Gene names
	genenames <- colnames(expdata)
	ngenes <- length(genenames)	
	
	# Normalize expression data for each gene
	if (normalizeexp)
		expdata <- scale(expdata)
	
	# If needed, load TF list
	if (is.null(tflist)) {
		# No TF list or file provided, we take all genes as TF
		tflist <- genenames
	} else if (length(tflist)==1 && is.na(match(tflist,genenames))) {
		# If this is a single string which is not a gene name, then it should be a file name
		tflist <- read.table(tflist , header=0)
		tflist <- as.matrix(tflist)[,1]
	}
	
	# Make sure there are no more steps than variables
	if (nstepsLARS>length(tflist)-1){
		nstepsLARS<-length(tflist)-1
		if (nstepsLARS==0){cat('Too few transcription factors! \n',stderr())}
		if (verb){
		cat(paste('Variable nstepsLARS was changed to: ',nstepsLARS,'\n')) }}

	# Locate TF in gene list by matching their names
	ntf <- length(tflist)
	tfindices <- match(tflist,genenames)
	if (max(is.na(tfindices))) {
		stop('Error: could not find all TF in the gene list!')
	}
	
	# Number of predictions to return
	Kmax <- ntf*ngenes
	if (K==-1) K<-Kmax
	K <- min(K,Kmax)
	
	# Prepare scoring matrix
	if (allsteps) {
		scorestokeep <- nstepsLARS
	} else {
		scorestokeep <- 1	
	}
	score <- list()
	
	# A small function to score the regulators of a single gene
	stabselonegene <- function(itarget) {
		if (verb) {
			cat('.')
			}

		# Name of the target gene
		targetname <- genenames[itarget]		
		# Find the TF to be used for prediction (all TF except the target if the target is itself a TF)
###		predTF <- tfindices[!match(tflist,targetname,nomatch=0)]
           predTF <- (num+1):ncol(expdata)
		r <- stabilityselection(as.matrix(expdata[,predTF]), as.matrix(expdata[,itarget]), nbootstrap=nbootstrap, nsteps=nstepsLARS, alpha=alpha)
		sc <- array(0,dim=c(ntf,scorestokeep),dimnames = list(tflist,seq(scorestokeep)))
		if (allsteps) {
			sc[predTF,] <- t(r)
		} else {
			sc[predTF,] <- t(r[nstepsLARS,])
		}
		invisible(sc)
	}
	
	# Treat target genes one by one
	if (usemulticore) {
		score <- mclapply(seq(num),stabselonegene,mc.cores=8)
	} else {
		score <- lapply(seq(num),stabselonegene)	
	}
	# Rank scores
	edgepred <- list()
	for (i in seq(scorestokeep)) {
		# Combine all scores in a single vectors
		myscore <- unlist(lapply(score,function(x) x[,1,drop=FALSE]))
		ranki <- order(myscore,decreasing=TRUE)[1:K]
		edgepred[[i]] <- data.frame(list(tf=tflist[(ranki-1)%%ntf+1] , target=genenames[(ranki-1)%/%ntf+1] , score=myscore[ranki]))
	}
	
	# Print and return the result
	if (allsteps) {
		if (nchar(outfile)>0) {
			for (i in seq(length(edgepred))) {
				write.table( edgepred[[i]], file=paste(outfile,i,sep=''), quote=FALSE, row.names=FALSE, col.names=FALSE, sep='\t')
			}
		}
		return(edgepred)
	} else {
		if (nchar(outfile)>0) {
			write.table( edgepred[[1]], file=outfile, quote=FALSE, row.names=FALSE, col.names=FALSE, sep='\t')
		}
		return(edgepred[[1]])
	}
}

#args <- commandArgs(trailingOnly = TRUE)
#print(args)

TIGRESSCmdLine(commandArgs(trailingOnly = TRUE))
