from z3 import *

def main():
    s = [BitVec("c" + str(i), 32) for i in range(16)]
    solver = Solver()
    solver.add(
        Sum(*s) == 0x42e,
        Sum(*s[0:4]) == Sum(*s[8:12]),
        Sum(*s[4:8]) == Sum(*s[12:16]),
        Sum(*s[0:4]) + 0xb == Sum(*s[4:8]),

        # englsh alphabet restriction
        *[c >= 65 for c in s],
        *[c <= 90 for c in s],
    )
    while solver.check() == sat:
        model = solver.model()
        result = "".join([chr(model.eval(c).as_long()) for c in s])
        print(result)

        solver.add(Or(*[c != model[c] for c in s]))


if __name__ == "__main__":
    main()
