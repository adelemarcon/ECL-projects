from club import *

c = Club('CMECL')
a = Adherent('Adèle',12)
s = Activite('Slackline')
ski = Activite('Ski alpin')
b = Adherent('Brigitte',3)

c.ajout_adherent(a)
c.associe(12,'Slackline')
c.associe(13,'ski')
c.ajout_adherent(b)
s.ajout_adherent(a)

print('\n--- Liste des adhérents à CMECL ---')
c.affiche_activistes()

print("\n--- Liste des adhérents à l\'activité Slackline ---")
s.affiche_adherents()