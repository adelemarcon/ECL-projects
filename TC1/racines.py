from math import sqrt
def trinome(a,b,c):
    delta = b**2 - 4*a*c
    if delta > 0.0:
        assert(a != 0)
        racine_delta = sqrt(delta)
        return (2, (-b-racine_delta)/(2*a), (-b+racine_delta)/(2*a))
    elif delta < 0.0: return (0,)
    else:
        assert (a != 0)
        return (1, (-b/(2*a)))
if __name__ == "__main__":
    print(trinome(3,-2,-1))
    
min=max=0
val = input("donner le premier entier")
try:
    val = int(val)
    min=max=val
except ValueError:
    print("On a demandé un entier...")

while True:
    try:
        val = input("donner un entier")
        val = int(val)
        if val < min:
            min = val
        if val > max:
            max = val
    except ValueError:
        print("Bah alors ?")
        exit(0)
    except EOFError:
        print("c'est fini : min =",min," max = ",max,)
        break
input("?")