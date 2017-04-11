# aeronet
---

These are my personal Matlab routines to analyze NASA Aeronet
sunphotometer data. Well, not really analyze, mostly read and
plot. Here is what you need to do.

First, go to the download page:

https://aeronet.gsfc.nasa.gov/cgi-bin/webtool_opera_v2_new

And select some station. You will be presented with a menu for
selecting the time interval, and also the products and level you
want. The page will look like this: 

```
------------------------------------------------------------
Download Data for Ji_Parana
Select the start and end time of the data download period:
START:	Day/Month/Year           END:	Day/Month/Year

Direct Sun Products	             Select

Aerosol Optical Depth (AOD)      Level 1.0 
with PW and Angstrom             Level 1.5 
                                 Level 2.0 

Instrument Information           Single File 
                                 Merge with AOD 

                                 Level 1.0
Total Optical Depth*             Level 1.5
                                 Level 2.0

(SDA) Retrievals --              Level 1.0
Fine Mode AOD, etc.              Level 1.5
                                 Level 2.0

Data Format
() All Points   () Daily Averages       () Monthly Averages

DOWNLOAD
------------------------------------------------------------
```

![download page form Aeronet](picdownload.png)

When you select what you want and click on download, you'll get a zip
file with all the data inside. See the folder ExampleData/ for an
example. The file name will look like this:

YYMMDD_YYMMDD_SITE.something

This tables shows which files you get in each case:

|Option selected | File you get
|------| ----
|AOD Lev.1.0             |site_id.lev10                   |
|AOD Lev.1.5             |site_id.lev15                   |
|AOD Lev.2.0             |site_id.lev20                   |
|Inst. Single File       |site_id.solar_info              |
|Inst. Merge with AOD    |=> will be added to "lev" files   |
|Total OD Lev.1.0        |site_id.tot10                   |
|Total OD Lev.1.5        |site_id.tot15                   |
|Total OD Lev.2.0        |site_id.tot20                   |
|SDA Lev.1.0             |site_id.ONEILL_10               |
|SDA Lev.1.5             |site_id.ONEILL_15               |
|SDA Lev.2.0             |site_id.ONEILL_20               |

For each of these types of files, you have one routine to read it:

|Matlab routine | File it applies to
|------| ----
|aeronet_read_lev.m    |=> lev10, 15 or 20     |
|aeronet_read_tot.m    |=> tot10, 15 or 20     |
|aeronet_read_ONEILL.m |=> ONEILL_10, 15 or 20 |

Note that you also have the inversions download page:

https://aeronet.gsfc.nasa.gov/cgi-bin/webtool_opera_v2_inv

Which has many more download options. The table below lists the files
you get when you select each of the available variables.

|Option selected | File you get
|------| ----
|Aerosol Size Distribution	        |site_id.siz
|Complex Index of Refraction	    |site_id.rin
|Coincident Aerosol Optical Depth   |site_id.aot
|Volume Mean Radius, etc..          |site_id.vol
|Absorption Aerosol Optical Depth	|site_id.tab
|Extinction Aerosol Optical Depth	|site_id.aot2
|Single Scattering Albedo	        |site_id.ssa
|Asymmetry Factor	                |site_id.asy
|Phase Functions	                |site_id.pfn, site_id_fine.pfn and site_id_coarse_pfn
|Radiative Forcing	                |site_id.force
|Spectral Flux	                    |site_id.flux
|Combined File                      |site_id.dubovik

I did not write routines for reading all of these! I just did for the
ones I need, which is the size distritions and the absorption optical
depth. If you want to addapt one of my scripts to read the others
files, fell free to do so. I would be glad to review it and include it
in here.

Let's do an example. If you have not done so yet, download the big zip
file (25Mb) and uncompress it. You should then have a folder
ExampleData/ with a bunch of files for 'Balbina' site inside.
Now open matlab and run the example script 'aeronet_plot_siz.m'.
You should get two plots for the size distributions.

