# -*- coding: utf-8 -*-

"""
Created on Fri Mar 31 07:36:18 2023

@author: pauli et Lucie
"""

import numpy as np
import pandas as pd
class Arules:
    
    def __init__(self,list_item:list,dico:dict):
        """ receives a list of itemsets lists and a dictionnary and calls reset"""
        self.list_itemsets = list_item
                
        self.support_itemsets = dico
        self.reset()   
        
  #--------------------------------------------------------------------------------
     
        
    def reset (self):
          """ method without parameters and returns nothing"""
          self.rules = []
    def support (self, lhs: tuple, rhs: tuple) -> float:
        """
        Parameters
        ----------
        lhs : tuple
            Correspond à l'itemset en partie gauche de la règle.
        rhs : tuple
            Correspond à l'itemset en partie droite de la règle.

        Returns
        -------
        float
            Estimation de la probabilité d'apparition de X.
        """    
        
        
        rhs=tuple(rhs)
        union=tuple(lhs)+tuple(rhs)
      
        l=sorted(list(union))
       
        l=tuple(l)
       
        return self.support_itemsets[l]
    
    def confidence (self, lhs: tuple, rhs: tuple) -> float:
        """
        Parameters
        ----------
        lhs : tuple
            Correspond à l'itemset en partie gauche de la règle.
        rhs : tuple
            Correspond à l'itemset en partie droite de la règle.

        Returns
        -------
        float
            Estimation de la probabilité d'apparition de Y sachant X.
        """        
        
        supp_xy = self.support(lhs,rhs)    
        
       
        supp_x =self.support_itemsets[lhs] 
        
        conf= float(supp_xy/supp_x)
        return conf   
    def lift (self, lhs: tuple, rhs: tuple) -> float:
        """
          Parameters
          ----------
          lhs : tuple
              Correspond à l'itemset en partie gauche de la règle.
          rhs : tuple
              Correspond à l'itemset en partie droite de la règle.

          Returns
          -------
          float
              DESCRIPTION."""           
            
        supp_xy = self.support(lhs,rhs)
        supp_x = self.support_itemsets[lhs] 
        supp_y= self.support_itemsets[rhs]    
        denom=float(supp_x*supp_y)
    
        lift = (supp_xy)/(denom) 
        return lift                                    
                 
    def lift_diag (self, lhs: tuple, rhs: tuple) -> str:
        
 
        
        if self.lift (lhs, rhs) == 1: return f" ne pas utiliser {lhs}-> {rhs}"
        elif self.lift (lhs, rhs) <1: return f" {lhs} et {rhs} ne peuvent pas co-exister dans une règle"
        elif self.lift (lhs, rhs) >1: return f" {lhs} -> {rhs} est prédictive "
             
    def leverage (self, lhs: tuple, rhs: tuple) -> float:
        """
        Parameters
        ----------
        lhs : tuple
            Correspond à l'itemset en partie gauche de la règle.
        rhs : tuple
            Correspond à l'itemset en partie droite de la règle.

        Returns
        -------
        float
            DESCRIPTION.
        """            
        
        supp_xy = self.support(lhs, rhs)
        supp_x = self.support_itemsets[lhs]
        supp_y = self.support_itemsets[rhs]
        
        return supp_xy - (float(supp_x * supp_y))      
     
    def conviction (self, lhs: tuple, rhs: tuple) -> float:
        """
        Parameters
        ----------
        lhs : tuple
            Correspond à l'itemset en partie gauche de la règle.
        rhs : tuple
            Correspond à l'itemset en partie droite de la règle.

        Returns
        -------
        float
            DESCRIPTION.
        """        
        
        supp_y= self.support_itemsets[rhs]
        confiance = self.confidence(lhs, rhs)
               
        if confiance == 1: return None                     
        else: return (1 - supp_y) / (1- confiance)   

    def cross_product (self, L: list, k: int) -> list:
        """
        Parameters
        ----------
        list_item : list
            Receives an itemsets list.
        taille : int
            Receives len(list).

        Returns
        -------
        list
            Returns a list of itemsets of len= len(list)+1.

        """
        
        
        rep=[]
        taille=len(L)
        for i in range(taille -1):
            j=i+1
            while j<taille and L[i][:-1] == L[j][:-1]:
                nouvo=L[i]+L[j][-1:]
                
                if all([nouvo[:p]+nouvo[p+1:] in L for p in range (k+1)]):
                    
                    rep.append(nouvo)
                    
                
                
                
                j+=1
        
        
        return rep
                
    def validation_rules (self, itemset: tuple, RHS: list, seuil: float) -> list:
        """
             Parameters
        ----------
        item : tuple
            k-itemset .
        rhs : list
            list of p-itemsets (rhs).
        seuil : float
            seuil minimal de confiance.

        Returns
        -------
        list
            DESCRIPTION.

        """
        
        variable_locale = []
                                                           
                                                   
        for i in range(0,len(RHS)):
        #construction de la partie de gauche
            
            rhs=set(RHS[i])
            itm=set(itemset)
        
            lhs=tuple(sorted(set(itm)-set(rhs)))
           
            score = self.confidence(lhs,rhs)                                   
            if score >= seuil:                                                  
                variable_locale.append(RHS[i])                                  
             
                règle=(lhs,RHS[i])
                self.rules.append(règle)                                       
           
        print("variable locale ", self.rules)
        return variable_locale                                                          
        
    def build_rules (self, item: tuple, rhs_c: list, seuil: float):
        """
        

        Parameters
        ----------
        item : tuple
            itemset de référence.
        rhs_c : list
            liste des items de taille 1 qui se trouvent dans item.
        seuil : float
            seuil de confiance minimal.

        Returns
        -------
        None.

        La fonction va construire toutes les règles possibles pour un itemset particulier.
        """
        
        
        
        
        
        k=len(item)
        size_rhs=1
        #initialiser la liste des parties de droites 
        #avec les partis de droites de taille 1
        liste_rhs=rhs_c
        
        while len(liste_rhs)>1 and k>size_rhs+1 : 
            size_rhs=size_rhs+1
            liste_rhs=self.cross_product(liste_rhs,1)
            
            liste_rhs=self.validation_rules(item,liste_rhs,seuil)
            
        
        
    def generate_rules(self, seuil_min: float):
        """
                    Parameters
            ----------
            seuil_min : float
                seuil min pour qu'une règle soit acceptée.
    
            Returns
            -------
            None.
    
        """
        self.reset()
        
        
        for i in range (0,len(self.list_itemsets)):
            
         
                
            
            if len(self.list_itemsets[i][0])==2:
            
                for a in range (len(self.list_itemsets[i])):
                    rhs = [ tuple([x]) for x in self.list_itemsets[i][a] ]
                    
                    item=self.list_itemsets[i][a]
                    
                    self.validation_rules(item,rhs,seuil_min) #pb
            
            elif len(self.list_itemsets[i][0])>2:
            
                for b in range (len(self.list_itemsets[i])):
                    rhs = [ tuple([x]) for x in self.list_itemsets[i][b] ]
                    
                    item=self.list_itemsets[i][b]
                    self.build_rules(item,rhs,seuil_min)
                              
 
    def main(self,seuil_min: float)-> pd.core.frame.DataFrame:
        """create a dataframe with all functions"""
      
        

        
        
        lhs=[]
        rhs=[]
        lhs_support=[]
        rhs_support=[]
        support=[]
        lift=[]
        leverage=[]
        conviction=[]
        confidence=[]
        
       
        self.generate_rules(seuil_min)
        print(len(self.rules))
          
        for i in range (0,len(self.rules)):
            for j in range(1,len(self.rules[i])):
                
                 l=self.rules[i][j-1]
                 r=self.rules[i][j]
                 
                 lhs.append(l)
                 rhs.append(r)
                
                 lhs_support.append(self.support_itemsets[l])
                 rhs_support.append(self.support_itemsets[r])
                   
                 support.append(self.support(l,r))
                   
                 lift.append(self.lift(l, r)) 
                 leverage.append(self.leverage(l, r))  
                 confidence.append(self.confidence(l, r))
                    
                 if self.confidence(l,r)==1 : 
                     conviction.append(np.inf)
                    
                 else : 
                     conviction.append(self.conviction(l,r))
            
                
                

        df=pd.DataFrame({'lhs':lhs,'rhs':rhs,
         'lhs_support':lhs_support,
         'rhs_support':rhs_support,
        'support':support,
        'confidence':confidence,
         'lift':lift,
         'leverage':leverage,
         'conviction':conviction})
        
        return df
            


        