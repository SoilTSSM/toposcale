#=======================================================================================================
#			SIMULATION BOX (S)
#=======================================================================================================
#sequence of coarse grids to compute corresponding to 1:n reanlysis gridboxes (can be sequence if run locally or single value automaticlly written by GC3pie in cloud mode)
nboxSeq=1:4

#=======================================================================================================
#			SWITCHES
#=======================================================================================================
#MAIN SIMULATION MODES
parTscale=FALSE #parallel tscale #switches
fetchERA=FALSE	# retreive ERA forcing from ECMWF servers?
swTopo=TRUE
#=======================================================================================================
#			MOST COMMON SETTINGS
#=======================================================================================================
#TSCALE
startDate='2012-11-02 00:00:00' #start cut of driving climate (ERA format) yyyy-mm-dd h:m:s
endDate='2012-11-04 00:00:00'#end cut of driving climate 


#=======================================================================================================
#			PACKAGES
#=======================================================================================================
require(ncdf)
require(raster)
require(rgdal)
require(insol)
require(IDPmisc)
require(colorRamps)
require(Hmisc)
require(gdata)
require(gtools)
require(gmodels)

#======================================================================================
#	`			INITIAL SOURCE
#======================================================================================
source(paste(root,'/src/getERA_src.r',sep=''))
source(paste(root,'/src/gt_control.r',sep=''))
source(paste(root,'/src/tscale_src.r',sep=''))
source(paste(root,'/src/surfFluxSrc.r',sep=''))
source(paste(root,'/src/solar_functions.r',sep=''))
source(paste(root,'/src/solar.r',sep=''))
source(paste(root,'/src/solar_geometry.R',sep=''))
source(paste(root,'/src/solarPartition.R',sep=''))
source(paste(root,'/src/sdirEleScale.R',sep=''))
source(paste(root,'/src/sdifSvf.R',sep=''))

#=======================================================================================================
#			DIRECTORIES/PATHS TO SET
#=======================================================================================================
epath=paste(root,'sim/',sep='') #created manually
srcRoot=paste(root,'src/',sep='')

#=======================================================================================================
#			PARAMETERS TO SET: TSCALE
#=======================================================================================================
pfactor=0.25 				#liston precipitation parameter
#other
step=3 					#time step of accumulated fields
tz=1 				#timezone, negative = west (used in package:insol)
#======================================================================================
#				INFILES
#======================================================================================

eraBoxEleDem=paste(root,'/sim/in/dem.tif',sep='')  # domain DEM  (longlat)
dshp2=shapefile(paste(root,'/sim/in/ERADomainWGS.shp',sep=''))#domain shp for getting ERA (must be longlat)

#method to apply climatology to get subgrid distribution of P
climtolP=FALSE # default = FALSE
if(climtolP==TRUE){
#precip grids
subWeights=paste(root,'/sim/in//subWeights.tif',sep='')
idgrid=paste(root,'/sim/in//idgrid.tif',sep='')
}

#listpoints=paste(root,'/sim/in/listpoints.txt',sep='') #location of tscale points

#shapefile of points to simulate attributes ele, slp, asp, svf [note attribute headings lowercase]
points_shp=shapefile(paste(root,'/sim/in/stations.shp',sep=''))

#===============================================================================
#				ERA FETCH PARAMETERS
#=============================================================================
#only relevant if fetchERA=TRUE
parNameSurf=c( 'dt', 'strd', 'ssrd', 'p', 't', 'toa')
parCodeSurf=c(168,175,169,228,167,212)

parNamePl=c('gpot','tpl','rhpl','upl','vpl')
parCodePl=c(129,130,157,131,132)

#mf=read.table( '/home/joel/data/ibutton/IB_dirruhorn/mf_IB.txt', sep=',' ,header=T)
dd="20121101/to/20121105"# date range yyyymmdd

grd='0.75/0.75'	# resolution long/lat (0.75/0.75) or grid single integer eg 80
plev= '500/650/775/850/925/1000'	#pressure levels (mb), only written if levtype=pl


