from z3 import *

def main():
    s = [BitVec("c" + str(i), 32) for i in range(6)]
    solver = Solver()
    solver.add(
        Sum([ c ^ i for i, c in enumerate(s) ]) == 635,

        *[c >= 21 for c in s],
        *[c <= 122 for c in s],
    )
    while solver.check() == sat:
        model = solver.model()
        result = "".join([chr(model.eval(c).as_long()) for c in s])
        print(result)

        solver.add(Or(*[c != model[c] for c in s]))


if __name__ == "__main__":
    main()
