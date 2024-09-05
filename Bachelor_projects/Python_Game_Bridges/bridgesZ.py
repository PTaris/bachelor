#=============================================================================
"""BRIDGES : play the 'Bridges' puzzle game"""
# ==============================================================================
__author__  = "Taris Pauline"
__version__ = "3.0" 
__date__    = "2022-12-11"
# ==============================================================================
from ezTK import *
from ezCLI import read_csv
from math import *
from random import choice

# ------------------------------------------------------------------------------
class Bridges_Game(object):
  """kernel class for the 'Bridges' game"""
  # ----------------------------------------------------------------------------
  def __init__(self, filename):
    """load all levels from CSV file, setup first level, ..."""
    self.levels = read_csv(filename) # load all levels from provided CSV file
    self.setup(10) # setup level manually
  # -------------------------------------------------------------------------
  def setup(self, level=10):# setup level manually
    """extract all parameters from provided game level"""
    self.level = max(0, min(len(self.levels), level)) # clamp to valid range
    self.bridges, self.rows, self.cols, self.grid = self.levels[self.level]
    
# ------------------------------------------------------------------------------
class Bridges_Win(Win):
  """interface class for the 'Bridges' game"""
  # ----------------------------------------------------------------------------
  def __init__(self, filename):
    """build initial window setup"""
    Win.__init__(self, title='BRIDGES', key=self.on_key, grow=False, op=2, click=self.on_click)
    self.levels = read_csv(filename)
    self.game = Bridges_Game(filename) # create instance of kernel class
    self.width = self.winfo_screenwidth()-100 # get width of computer screen
    self.height = self.winfo_screenheight()-70 # get height of computer screen
    self.canvas = Canvas(self, width=self.width, height=self.height, bg='#177BB3')
    self.color=('#FFF',"#FEE0FF","#FFFEA3","#FF5BF0")

    # list to save the coordinates of the isles clicked empty
    self.liste_clic=[]
    #0 click on the initial window, it will count the clicks later
    self.clic=0
    # empty list for the widths of the lines later
    self.liste_trait=[]
    # it will count the clicks for the widths of the lines
    self.clic_trait=0
    # empty list to save the number of the isle clicked later 
    self.liste_isle=[]
    #list empty to save the abscissa of the isle clicked later
    self.liste_x=[]
    #list empty to save the ordinates of the isle clicked later
    self.liste_y=[]
    

    self.show(); self.loop() # show first grid and launch interaction loop
  # ----------------------------------------------------------------------------
  def show(self):
    """show grid for current level and update window title"""
    game, canvas, w, h = self.game, self.canvas, self.width/2, self.height/2
    level, rows, cols, bridges = game.level, game.rows, game.cols, game.bridges
    self.title = f"BRIDGES : Level {level} = {rows}x{cols} --> {bridges} bridges"
    # ----------------------------------------------------------------------------
    step = min(w/cols, h/rows) # compute grid step from canvas and grid sizes
    ax, ay = w-step*cols, h-step*rows; bx, by = ax+step, ay+step # grid offsets
    canvas.delete('all') # delete all canvas items of previous grid
    for row in range(rows): # loop over grid rows and draw horizontal lines
      canvas.create_line(ax, by+2*row*step, 2*w-ax, by+2*row*step, fill='#000')
    for col in range(cols): # loop over grid cols and draw vertical lines
      canvas.create_line(bx+2*col*step, ay, bx+2*col*step, 2*h-ay, fill='#000')

    #use of the csv file to establish the number of bridges,rows,cols.
    self.nb_bridge=self.levels[level][0]
    self.nb_rows=self.levels[level][1]
    self.nb_cols=self.levels[level][2]
    #position of the isle and their number 
    self.grid_content=self.levels[level][3]
    contenu = self.grid_content
    texte= self.nb_bridge

    #list to save the coordinates of the isle
    self.liste_coordinate=[]
    #list to save their number
    self.liste_contenu=[]

  
    # loop over the self.grid_content
    for i in range(0,len(contenu),1):
      conten=contenu[i] #number of the isle i will be useful for the text inside the circle 
      if conten != ".":   
        self.liste_contenu.append(conten)

        #will be use to move col by col
        step_col=0
        # will be use to move row by row
        step_ligne=0

        #loop over the grid to place the isles
        while step_col<cols: # loop over the cols
          for step_ligne in range (0,rows):#over the rows

            
            if i==step_col or step_col+ cols*step_ligne==i  :
              #create isle with a position based on a formule found with print tests
              self.canvas.create_oval(ax+step/2+step_col*2*step,ay+step/2+(2*(i//cols))*step,bx+step/2+step_col*2*step ,by+step/2+(2*(i//cols))*step,width=6, fill=self.color[0])
              self.isle=self.canvas.create_oval(ax+step/2+step_col*2*step,ay+step/2+(2*(i//cols))*step,bx+step/2+step_col*2*step ,by+step/2+(2*(i//cols))*step,width=6, fill=self.color[0])
                
         

              
              #variables for the diameter of the isle 
              self.width_isle=abs((ax+step/2+step_col*2*step)-(bx+step/2+step_col*2*step))
              self.height_isle=abs((ay+step/2+(2*(i//cols))*step-(by+step/2+(2*(i//cols))*step)))


              #coordinates for the position of the numbers
              self.x_text= ax+step/2+step_col*2*step+step/2
              self.y_text= ay+step/2+(2*(i//cols))*step+step/2

              #use of the conten from self.liste_contenu to have the right number 
              self.canvas.create_text((self.x_text,self.y_text), text=conten, fill='#000',font="Arial 30 bold")
              self.text=self.canvas.create_text((self.x_text,self.y_text), text=conten, fill='#000',font="Arial 30 bold")


              #save the coordinates of isle
              self.x_isle=int(self.x_text)
              self.y_isle=int(self.y_text)
              self.coordinate=(self.x_isle,self.y_isle)
              
             
              self.liste_coordinate.append(self.coordinate)
            
              
              
              
              
          step_col=step_col+1

    

    #Because of the loop I have to delete the duplicates coordinates :
    
    self.liste_fixed=[]#list of the coordinates with no double 
    for (x,y) in self.liste_coordinate:
      if (x,y) not in self.liste_fixed:
        self.liste_fixed.append((x,y))
    
        
  



  #========================================================

  def on_click(self, widget,code,mods) :

   #widths for the bridges
    widths=(5,10,20)
  
    
    #correspond to the radius of the isle by using the diameter 
    surface=int(self.width_isle/2)
    
    
    if widget == self.canvas :
      #track the mouse positin
      x = widget.winfo_pointerx() - widget.winfo_rootx()
      y = widget.winfo_pointery() - widget.winfo_rooty()
      
      
            
    #loop over the isles coordinates  
    for i in range (0,len(self.liste_fixed)):
        #store the abscissa and ordinates of the isle
        (sur_x,sur_y)=self.liste_fixed[i]
        
        #if the coordinate of the mouse is on the circle ==> between the center minus the radius and the center plus the radius 
        if (sur_x-surface) <= x <= (sur_x+surface) and (sur_y-surface) <= y <= (sur_y+surface):
            if code == 'LMB': #left click
              
                #count the clicks
                self.clic=self.clic+1
                
                #change the color of the isle clicked
                self.canvas.create_oval(sur_x-surface,sur_y-surface,sur_x-surface+self.width_isle,sur_y-surface+self.height_isle,width=6, fill=self.color[1])
                self.canvas.create_text((sur_x,sur_y), text=int(self.liste_contenu[i]), fill='#000',font="Arial 30 bold")

                #coordinates of the isles clicked
                self.liste_x.append(sur_x)
                self.liste_y.append(sur_y)
              
                isle_clic=sur_x,sur_y
                self.liste_clic.append(isle_clic)

                #list to save the number of the isles clicked 
                self.liste_isle.append(i)

               
               #coordinates of the before last isle clicked  
                self.x,self.y=self.liste_clic[self.clic-2]
                #coordinates of the last isle clicked
                self._x,self._y=self.liste_clic[self.clic-1]
                
            
                #diagonal trait    
                if  self.x !=self._x and self.y!=self._y :
                    print("Tour interdit ! ")
              

              
            
                elif self.x !=self._x   or self.y!=self._y :

                    #number of the last isle and before last isle clicked
                    b=len(self.liste_isle)
                    last_isle=self.liste_isle[b-1]
                    before_isle=self.liste_isle[b-2]

                  
                    #for a click on another isle the width of the bridge is the min
                    self.clic_trait =0
                    
                    #if it's the first isle clicked the isle a the beginning of the bridge loose only one 
                    if self.clic==2:
          # the bridge is always between the before last isle clicked and the last
                        self.canvas.create_oval(self.x-surface,self.y-surface,self.x-surface+self.width_isle,self.y-surface+self.height_isle,width=6, fill=self.color[1])
                        self.canvas.create_text((self.x,self.y), text=int(self.liste_contenu[before_isle])-1, fill='#000',font="Arial 30 bold")
                        
                        self.canvas.create_oval(self._x-surface,self._y-surface,self._x-surface+self.width_isle,self._y-surface+self.height_isle,width=6, fill=self.color[2])
                        self.canvas.create_text((self._x,self._y), text=int(self.liste_contenu[last_isle])-1, fill='#000',font="Arial 30 bold")

                        line=self.canvas.create_line(self.x,self.y,self._x,self._y, width=widths[self.clic_trait], tag=f"pont{i}",fill="#FFF")# the tag is useful for erasing the bridges later
                        widget.tag_lower(line)#hide the line under the circle


                    #if the isle is not the first, the before last isle lose two points because of the links and the last isle only one because it is at the end of the last bridge 
                    elif self.clic>2 :    
                      
                        self.canvas.create_oval(self.x-surface,self.y-surface,self.x-surface+self.width_isle,self.y-surface+self.height_isle,width=6, fill=self.color[2])
                        self.canvas.create_text((self.x,self.y), text=int(self.liste_contenu[before_isle])-2, fill='#000',font="Arial 30 bold")

                        self.canvas.create_oval(self._x-surface,self._y-surface,self._x-surface+self.width_isle,self._y-surface+self.height_isle,width=6, fill=self.color[2])
                        self.canvas.create_text((self._x,self._y), text=int(self.liste_contenu[last_isle])-1, fill='#000',font="Arial 30 bold")

                        line=self.canvas.create_line(self.x,self.y,self._x,self._y, width=widths[self.clic_trait], tag=f"pont{i}",fill="#FFF")
                        widget.tag_lower(line)
                   

                
                #if the same isle is clicked more than one time
                elif self.x ==self._x and self.y==self._y:

                    #the line is wider
                    self.clic_trait= self.clic_trait +1
                    if self.clic_trait>2:
                        print("épaisseur maximale du pont")
                    

                   #the last isle clicked is find by subtracting the number of clicks on the same isle
                    self.x,self.y=self.liste_clic[self.clic-(2+self.clic_trait)]
                    self._x,self._y=self.liste_clic[self.clic-(1+self.clic_trait)]

                    line_double=self.canvas.create_line(self.x,self.y,self._x,self._y, width=widths[self.clic_trait], tag=f"pont{i}",fill="#FFF")
                    widget.tag_lower(line_double)

                    #there are repetitions but I didn't know how to do otherwise
                    b=len(self.liste_isle)
                    last_isle=self.liste_isle[b-(1+self.clic_trait)]
                    before_isle=self.liste_isle[b-(2+self.clic_trait)]

                    
                    if self.clic_trait==1:# if there is a double click the before last isle lose 2+1 and the last isle 1+1 
               
                        
                        
                        self.canvas.create_oval(self.x-surface,self.y-surface,self.x-surface+self.width_isle,self.y-surface+self.height_isle,width=6, fill=self.color[3])
                        self.canvas.create_text((self.x,self.y), text=int(self.liste_contenu[before_isle])-3, fill='#000',font="Arial 30 bold")


                        self.canvas.create_oval(self._x-surface,self._y-surface,self._x-surface+self.width_isle,self._y-surface+self.height_isle,width=6, fill=self.color[3])
                        self.canvas.create_text((self._x,self._y), text=int(self.liste_contenu[last_isle])-2, fill='#000',font="Arial 30 bold")


                    elif self.clic_trait==2:# if there is a triple click the before last isle lose 2+2 and the last isle 1+2
                        
                        self.canvas.create_oval(self.x-surface,self.y-surface,self.x-surface+self.width_isle,self.y-surface+self.height_isle,width=6, fill=self.color[3])
                        self.canvas.create_text((self.x,self.y), text=int(self.liste_contenu[before_isle])-4, fill='#000',font="Arial 30 bold")


                        self.canvas.create_oval(self._x-surface,self._y-surface,self._x-surface+self.width_isle,self._y-surface+self.height_isle,width=6, fill=self.color[3])
                        self.canvas.create_text((self._x,self._y), text=int(self.liste_contenu[last_isle])-3, fill='#000',font="Arial 30 bold")

                
      
            
            elif code == 'RMB':#right click
                #the isle from the start is created
                self.canvas.create_oval(sur_x-surface,sur_y-surface,sur_x-surface+self.width_isle,sur_y-surface+self.height_isle,width=6, fill=self.color[0])
                self.canvas.create_text((sur_x,sur_y), text=int(self.liste_contenu[i]), fill='#000',font="Arial 30 bold")
      
                #delete the bridge with the tag
                self.canvas.delete(f"pont{i}")
                
    #the colors are differents to show the process


      
  # ----------------------------------------------------------------------------
  def on_key(self, widget, code, mods):
    """callback function for all keyboard events"""

    
    if code not in {'Prior','Next'}: return # wrong key
    level = self.game.level + (-1,1)[code == 'Next'] # next or previous level
    self.game.setup(level); self.show()
# ==============================================================================
if __name__ == "__main__": Bridges_Win('bridges.csv')

# ==============================================================================

















