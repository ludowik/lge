import math, random


class vec2(object):
    def __init__(self, x=0, y=0):
        self.x = x
        self.y = y

    def __iter__(self):
        yield self.x
        yield self.y

    def __iadd__(self, v):
        self.x += v.x
        self.y += v.y
        return self

    def __isub__(self, v):
        self.x -= v.x
        self.y -= v.y
        return self

    def __add__(self, v):
        return vec2(
            self.x + v.x,
            self.y + v.y
        )

    def __sub__(self, v):
        return vec2(
            self.x - v.x,
            self.y - v.y
        )

    def __mul__(self, coef):
        return vec2(
            self.x * coef,
            self.y * coef
        )

    @staticmethod
    def random(w=1, h=1):
        return vec2(
            random.random() * w,
            random.random() * h)

    def len(self):
        return math.sqrt(self.x ** 2 + self.y ** 2)

    def normalize(self, n=1):
        lenght = self.len()
        if lenght == 0:
            return vec2()
        lenght /= (n or 1)
        return vec2(
            self.x / lenght,
            self.y / lenght
        )


class vec3(object):
    def __init__(self, x=0, y=0, z=0):
        self.x = x
        self.y = y
        self.z = z

    def __iter__(self):
        yield self.x
        yield self.y
        yield self.z

    def __iadd__(self, v):
        self.x += v.x
        self.y += v.y
        self.z += v.z
        return self

    def __isub__(self, v):
        self.x -= v.x
        self.y -= v.y
        self.z -= v.z
        return self

    def __add__(self, v):
        return vec3(
            self.x + v.x,
            self.y + v.y,
            self.z + v.z
        )

    def __sub__(self, v):
        return vec3(
            self.x - v.x,
            self.y - v.y,
            self.z - v.z
        )

    @staticmethod
    def random(n=1):
        return vec3(
            random.random(),
            random.random(),
            random.random()).normalize(n)

    def len(self):
        return math.sqrt(self.x ** 2 + self.y ** 2 + self.z ** 2)

    def normalize(self, n=1):
        lenght = self.len()
        if lenght == 0:
            return vec3()
        lenght /= n
        return vec3(
            self.x / lenght,
            self.y / lenght,
            self.z / lenght
        )

    def cross(self, v):
        return vec3(
            self.y * v.z - self.z * v.y,
            self.z * v.x - self.x * v.z,
            self.x * v.y - self.y * v.x
        )

    def dot(self, v):
        return (
                self.x * v.x +
                self.y * v.y +
                self.z * v.z
        )
