
import numpy

def gaussian(x, sx, y=None, sy=None):

    """Returns an array of numpy arrays (a matrix) containing values between
    1 and 0 in a 2D Gaussian distribution
    
    arguments
    x		-- width in pixels
    sx		-- width standard deviation
    
    keyword argments
    y		-- height in pixels (default = x)
    sy		-- height standard deviation (default = sx)
    """
    # square Gaussian if only x values are passed
    if y == None:
        y = x
    if sy == None:
        sy = sx
	# centers	
    xo = x/2
    yo = y/2
    # matrix of zeros
    M = numpy.zeros([y,x],dtype=float)
    # gaussian matrix
    for i in range(x):
        for j in range(y):
            M[j,i] = numpy.exp(-1.0 * (((float(i)-xo)**2/(2*sx*sx)) + ((float(j)-yo)**2/(2*sy*sy)) ) )
    
    return M


def parse_fixations(fixations):
	
	"""Returns all relevant data from a list of fixation ending events
	
	arguments
	
	fixations		-	a list of fixation ending events from a single trial,
					as produced by edfreader.read_edf, e.g.
					edfdata[trialnr]['events']['Efix']

	returns
	
	fix		-	a dict with three keys: 'x', 'y', and 'dur' (each contain
				a numpy array) for the x and y coordinates and duration of
				each fixation
	"""
	
	# empty arrays to contain fixation coordinates
	fix = {	'x':numpy.zeros(len(fixations)),
			'y':numpy.zeros(len(fixations)),
			'dur':numpy.zeros(len(fixations))}
	# get all fixation coordinates
	for fixnr in range(len( fixations)):
		stime, etime, dur, ex, ey = fixations[fixnr]
		fix['x'][fixnr] = ex
		fix['y'][fixnr] = ey
		fix['dur'][fixnr] = dur
	
	return fix


def draw_heatmap(fixations, dispsize):

    fix = parse_fixations(fixations)
    
    # IMAGE
#     fig, ax = draw_display(dispsize, imagefile=imagefile)
    # HEATMAP
    # Gaussian
    gwh = 200
    gsdwh = gwh/6
    gaus = gaussian(gwh,gsdwh)
    # matrix of zeroes
    strt = int(gwh/2)
    heatmapsize = dispsize[1] + 2*strt, dispsize[0] + 2*strt
    heatmap = numpy.zeros(heatmapsize, dtype=float)
    # create heatmap
    for i in range(0,len(fix['dur'])):
        # get x and y coordinates
        #x and y - indexes of heatmap array. must be integers
        x = int(strt + int(fix['x'][i]) - int(gwh/2))
        y = int(strt + int(fix['y'][i]) - int(gwh/2))
        # correct Gaussian size if either coordinate falls outside of
        # display boundaries
        if (not 0 < x < dispsize[0]) or (not 0 < y < dispsize[1]):
            hadj=[0,gwh]
            vadj=[0,gwh]
            if 0 > x:
                hadj[0] = abs(x)
                x = 0
            elif dispsize[0] < x:
                hadj[1] = gwh - int(x-dispsize[0])
            if 0 > y:
                vadj[0] = abs(y)
                y = 0
            elif dispsize[1] < y:
                vadj[1] = gwh - int(y-dispsize[1])
            # add adjusted Gaussian to the current heatmap
            try:
                heatmap[y:y+vadj[1],x:x+hadj[1]] += gaus[vadj[0]:vadj[1],hadj[0]:hadj[1]] * fix['dur'][i]
            except:
                # fixation was probably outside of display
                pass
        else:                
            # add Gaussian to the current heatmap
            heatmap[y:y+gwh,x:x+gwh] += gaus * fix['dur'][i]
    # resize heatmap
    heatmap = heatmap[strt:dispsize[1]+strt,strt:dispsize[0]+strt]/len(fix['dur'])
    # remove zeros
    lowbound = numpy.mean(heatmap[heatmap>0])
    heatmap[heatmap<lowbound] = 0
    # numpy.NaN
    
    return heatmap