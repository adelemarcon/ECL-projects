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