from bibliotheque import *

# Creation d'une bibliotheque et de son conservateur
b = Bibliotheque('Bibliotheque ECL')
b.set_conservateur('Vivier','Merlin','rue des Papillons')
print('\n--- Conservateur :')
print('-------------------------------')
b.affiche_conservateur()

# Ajout de lecteurs
b.ajout_lecteur('Duval','Pierre','rue de la Paix',1)
b.ajout_lecteur('Dupond','Laurent','rue de la Gare',2)
b.ajout_lecteur('Martin','Marie','rue La Fayette',3)
b.ajout_lecteur('Dubois','Sophie','rue du Stade',4)

# Ajout de livres
b.ajout_livre('Le Pere Goriot','Honore de Balzac',101,2)
b.ajout_livre('Les Hauts de Hurlevent','Emilie Bronte',102,2)
b.ajout_livre('Le Petit Prince','Antoine de Saint Exupery',103,2)
b.ajout_livre('L\'Etranger','Albert Camus',104,2)

# Ajout de biliothécaires

b.ajout_bibliothecaire('Duval','Marion','rue des Hirondelles',1)
b.ajout_bibliothecaire('Desjardins','Anne','rue Sainte-Adèle',2)

# Affichage des lecteurs et des livres
print('\n--- Liste des lecteurs :')
print('-------------------------------')
b.affiche_lecteurs()
print('\n--- Liste des livres :')
print('-------------------------------')
b.affiche_livres()

# Recherches de lecteurs par numero
print('\n--- Recherche de lecteurs :')
print('-------------------------------')
lect = b.chercher_lecteur_numero(1)
if lect != None:
    print(lect)
else:
    print('Lecteur non trouvé')

lect = b.chercher_lecteur_numero(6)
if lect != None:
    print(lect)
else:
    print('Lecteur non trouvé')

# Recherches de lecteurs par nom
lect = b.chercher_lecteur_nom('Martin','Marie')
if lect != None:
    print(lect)
else:
    print('Lecteur non trouvé')
    
lect = b.chercher_lecteur_nom('Le Grand','Paul')
if lect != None:
    print(lect)
else:
    print('Lecteur non trouvé')

# Recherches de livres par numero
print('\n--- Recherche de livres :')
print('-------------------------------')
livre = b.chercher_livre_numero(101)
if livre != None:
    print('Livre trouve :',livre)
else:
    print('Livre non trouvé')

livre = b.chercher_livre_numero(106)
if livre != None:
    print('Livre trouvé :',livre)
else:
    print('Livre non trouvé')

# Recherches de livres par titre
livre = b.chercher_livre_titre('Les Hauts de Hurlevent')
if livre != None:
    print('Livre trouvé :',livre)
else:
    print('Livre non trouvé')

livre = b.chercher_livre_titre('Madame Bovarie')
if livre != None:
    print('Livre trouvé :',livre)
else:
    print('Livre non trouvé')
    
# Recherches de bibliothécaires par numero

print('\n--- Recherche de bibliothécaires :')
print('-------------------------------')
biblio = b.chercher_bibliothecaire_numero(1)
if biblio != None:
    print(biblio)
else:
    print('Bibliothécaire non trouvé')

biblio = b.chercher_lecteur_numero(96)
if biblio != None:
    print(biblio)
else:
    print('Bibliothécaire non trouvé')

# Recherche de Bibliothécaires par nom
biblio = b.chercher_bibliothecaire_nom('Desjardins','Anne')
if biblio != None:
    print(biblio)
else:
    print('Bibliothécaire non trouvé')

biblio = b.chercher_lecteur_nom('Pierre','Caillou')
if biblio != None:
    print(biblio)
else:
    print('Bibliothécaire non trouvé')

# Quelques emprunts
print('\n--- Quelques emprunts :')
print('-------------------------------')
b.emprunt_livre(1,101,1)
b.emprunt_livre(1,104,2)
b.emprunt_livre(2,101,1)
b.emprunt_livre(2,105,2)
b.emprunt_livre(3,101,1)
b.emprunt_livre(3,104,2)
b.emprunt_livre(4,102,1)
b.emprunt_livre(4,103,2)
b.emprunt_livre(1,102,7)
b.emprunt_livre(3,103,26)

# Affichage des emprunts, des lecteurs et des livres
print('\n--- Liste des emprunts :')
print('-------------------------------')
b.affiche_emprunts()
print('\n--- Liste des lecteurs :')
print('-------------------------------')
b.affiche_lecteurs()
print('\n--- Liste des livres :')
print('-------------------------------')
b.affiche_livres()

# Quelques retours de livres
print('\n--- Quelques retours de livres :')
print('-------------------------------')
b.retour_livre(1,101)
b.retour_livre(1,102)
b.retour_livre(3,104)
b.retour_livre(10,108)

# Affichage des emprunts, des lecteurs et des livres
print('\n--- Liste des emprunts :')
print('-------------------------------')
b.affiche_emprunts()
print('\n--- Liste des lecteurs :')
print('-------------------------------')
b.affiche_lecteurs()
print('\n--- Liste des livres :')
print('-------------------------------')
b.affiche_livres()

# Suppression de quelques livres
print('\n--- Quelques suppressions :')
print('-------------------------------')
rep = b.retrait_livre(101)
if not rep:
    print('Retrait du livre impossible')
else:
    print('Retrait du livre effectue')

b.retour_livre(2,101)

rep = b.retrait_livre(101)
if not rep:
    print('Retrait du livre impossible')
else:
    print('Retrait du livre effectue')

# Suppression de quelques lecteurs
rep = b.retrait_lecteur(1)
if not rep:
    print('Retrait du lecteur impossible')
else:
    print('Retrait du lecteur effectue')

b.retour_livre(1,104)

rep = b.retrait_lecteur(1)
if not rep:
    print('Retrait du lecteur impossible')
else:
    print('Retrait du lecteur effectue')
    
#Suppression de quelques bibliothécaires

rep = b.retrait_bibliothecaire(1)
if not rep:
    print('Retrait du bibliothécaire impossible')
else:
    print('Retrait du bibliothécaire effectue')
    
b.retour_livre(4,102)

rep = b.retrait_bibliothecaire(1)
if not rep:
    print('Retrait du bibliothécaire impossible')
else:
    print('Retrait du bibliothécaire effectue')

# Affichage des emprunts, des lecteurs et des livres
print('\n--- Liste des emprunts :')
print('-------------------------------')
b.affiche_emprunts()
print('\n--- Liste des lecteurs :')
print('-------------------------------')
b.affiche_lecteurs()
print('\n--- Liste des livres :')
print('-------------------------------')
b.affiche_livres()


