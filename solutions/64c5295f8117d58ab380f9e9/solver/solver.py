from z3 import *

def main():
    s = [BitVec("c" + str(i), 32) for i in range(12)]
    solver = Solver()
    solver.add(
        s[0]  + s[1]   == 0xa6,
        s[3]  ^ s[5]   == 0x50,
        s[6]  + s[2]   == 0xd7,
        s[4]  / s[7]   == 1,
        s[4]  * s[11]  == 0x3c0f,
        s[8]  - s[2]   == 9,
        s[9]  + s[3]   == 0x97,
        s[10] & s[11]  == 0x64,
        s[11] + s[0]   == 0xf3,
        s[10] + s[1]   == 0x94,
        s[9]  % s[2]   == 0x33,
        s[8]  ^ s[3]   == 0x16,
        s[7]  | s[4]   == 0x7f,
        s[6]  + s[5]   == 0xa2,
    )
    while solver.check() == sat:
        model = solver.model()
        result = "".join([chr(model.eval(c).as_long()) for c in s])
        print(result)

        solver.add(Or(*[c != model[c] for c in s]))


if __name__ == "__main__":
    main()
