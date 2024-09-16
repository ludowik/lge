class Color:
    def __init__(self, r=0, g=0, b=0, a=1):
        self.r = r
        self.g = g
        self.b = b
        self.a = a

    def __iter__(self):
        yield self.r
        yield self.g
        yield self.b
        yield self.a


white = Color(1, 1, 1)
black = Color(0, 0, 0)

gray = Color(0.5, 0.5, 0.5)

red = Color(1, 0, 0)
green = Color(0, 1, 0)
blue = Color(0, 0, 1)
