library("ggplot2")
argv <- commandArgs(T)
options(encoding="utf-8")
dat<-read.table(argv[1],header=T,row.names=1)
#df<-data.frame(id=rep(1:5,each=5),
#                  x=c(0,1,0,-1,0,
#                      0,0.8,0,-0.8,0,
#                      0,0.6,0,-0.6,0,
#                      0,0.4,0,-0.4,0,
#                      0,0.2,0,-0.2,0),
#                  y=c(1,0,-1,0,1,
#                      0.8,0,-0.8,0,0.8,
#                      0.6,0,-0.6,0,0.6,
#                      0.4,0,-0.4,0,0.4,
#                      0.2,0,-0.2,0,0.2))

df<-data.frame(id = rep(1:6,each=5),
		x = unlist(lapply(seq(0,1,length=6),function(x){c(x,0,-x,0,x)})),
                y = unlist(lapply(seq(0,1,length=6),function(x){c(0,x,0,-x,0)}))
               )

g<- ggplot(data=df,aes(x = x,y = y, group = factor(id)))+ geom_path(color="grey",alpha=0.5)+
    scale_x_continuous(limits = c(-1.2,1.2))+scale_y_continuous(limits = c(-1.2,1.2))+xlab("")+ylab("")


#df2 <- data.frame(id = rep("Sample",each=5),x=c(dat[1,1],0,-dat[3,1],0,dat[1,1]),y=c(0,dat[2,1],0,-dat[4,1],0))
df2 <- data.frame(id = rep(colnames(dat),each=5),
                  x = c(dat[1,1],0,-dat[3,1],0,dat[1,1],
                        dat[1,2],0,-dat[3,2],0,dat[1,2]),
                  y = c(0,dat[2,1],0,-dat[4,1],0,
                        0,dat[2,2],0,-dat[4,2],0))
gg<- g+geom_polygon(data=df2,aes(x=x,y=y,group=factor(id),fill=factor(id)))+theme(legend.title=element_blank())+scale_fill_manual(values =c(8,hsv(h=0.57,s=0.39,v=0.83,alpha=0.7)))
#gg<- g+geom_polygon(data=df2,aes(x=x,y=y,group=factor(id),fill=factor(id)))+theme(legend.position="none")+scale_fill_manual(values =c(8,hsv(h=0.57,s=0.39,v=0.83,alpha=0.7)))


df3 <- data.frame(x=c(1.1,0,-1.1,0),y=c(0,1.1,0,-1.1),label=rownames(dat))

ggg <- gg + annotate("text", x = df3$x, y = df3$y, label = df3$label, size = 5)
#CairoPDF("radar.pdf",family="NSimSun")
cairo_pdf("radar.pdf",family="SimSun")
ggg
dev.off()
