# -*- coding: utf-8 -*-
"""
Created on Thu Feb  9 10:14:58 2023

@author: P.TARIS and L.CHASTE

"""
#====================================================================

class Apriori:
    def __init__(self,parm:dict):
        """
        Parameters
        ----------
        parm : dict
            For each items: {tid: value}.

        Returns
        -------
        None.

        """
        self.dbase=parm
        self.reset()

#==========================================================================
        
    def reset(self): 
        """
        Receives nothing

        Returns
        -------
        None.
        """
        
        self.candidates_sz=1
        self.support_history=dict() #ou {}
        self.candidates={}
        for x in self.dbase:
            self.candidates[x]=[(a,) for a in self.dbase[x]]
        self.current={}
        for x,v in self.candidates.items():
            for itemset in v: 
                if itemset in self.current: 
                    self.current[itemset].add(x)
                else: 
                    self.current[itemset]={x}
                    
#==========================================================================
 
    def support(self,val:float)->dict:
        """    
        Parameters
        ----------
        val : float
            val is a float between 0 and 1.

        Returns
        -------
        dict
            From the dictionary self.current: {itemsets: support}.
        """

        a= {x:len(v)/len(self.dbase)
            for x,v in self.current.items()} 
        return {x:v for x,v in a.items() if v >=val}
          
#================================================================================    

    def scan_dbase(self,val:float): 
        """
        
        Parameters
        ----------
        val : float
            val is a float between 0 and 1.
            The function will update the self.support_history dictionary and modify self.current in order to keep only relevant information.

        Returns
        -------
        None.

        """
        
        c=self.support(val)
        self.support_history.update(c)

        for k in self.current.keys():
                self.current={k:self.current[k] for k in c }
                
#===================================================================================        
    def Lk (self)-> list:
        """
        Returns
        -------
        list
            Returns a sorted list of keys from self.current.
        """
        return sorted(self.current.keys())                     
    
#==================================================================================       
 
    def cross_product (self):
        """
        Method without parameters which modifies many variables.
     
        Returns
        -------
        None.

        """
        
        Lk = self.Lk()
        k = self.candidates_sz
        p = len(Lk)

        futur = {}
        for i in range(p-1):
            j = i+1
            
            while j<p and Lk[i][:-1] == Lk[j][:-1]:
                
                nouvo = Lk[i]+Lk[j][-1:]
                ok=True
                u=0
                
                while u < k+1 and ok : 
                    
                    ok=nouvo[:u]+nouvo[u+1:] in Lk
                    if ok==False :
                       print("")
                    else:
                        tid_i=self.current.get(Lk[i])
                        tid_j=self.current.get(Lk[j])
                        futur[nouvo]=tid_i.intersection(tid_j)
                    u+=1

                j = j+1

        self.current=futur
        candidates={}

        for itemset, set_of_tid in self.current.items():
            
            for tid in set_of_tid: 
                old= candidates.get(tid, [])
                old.append(itemset)
                candidates[tid] = old

        self.candidates=candidates
        self.candidates_sz=len(nouvo)
        k+=1
        
#=========================================================================================================

    def main (self,val:float)-> list:
        """
        Parameters
        ----------
        val : float
            val is a float between 0 and 1.

        Returns
        -------
        list
            Returns a list of itemsets' list.

        """
        
        self.reset()
        self.candidates_sz
        list_current=[]
        self.scan_dbase(val)
        Lk=self.Lk()
        
        if Lk!=[]:
            list_current.append(Lk)
        
        while len(self.current)>1:
            
            self.cross_product()
            self.scan_dbase(val)
            Lk=self.Lk()
    
            if Lk!=[]:
                list_current.append(Lk)
              
        return list_current
        
#==============================================================================