import time


class FrameTime(object):
    def __init__(self):
        self.nframes = 0
        self.fps = 0

        self.start_time = 0
        self.end_time = 0

        self.delta_time = 0
        self.elapsed_time = 0

        self.one_second = 0
        self.delta_frames = 0

    def compute_time(self):
        self.nframes += 1
        self.delta_frames += 1

        self.end_time = time.time()

        self.delta_time = self.end_time - self.start_time
        self.elapsed_time += self.delta_time

        self.one_second += self.delta_time
        if self.one_second >= 1:
            self.fps = self.delta_frames
            self.one_second = 0
            self.delta_frames = 0

        self.start_time = self.end_time
