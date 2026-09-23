# Horn-Schunck Optical Flow

A MATLAB implementation of the **Horn-Schunck optical flow algorithm** for estimating the apparent motion of pixels between two consecutive image frames.

## What is Optical Flow?

Optical flow describes the apparent movement of pixels between consecutive frames of a video or image sequence.

In this project, I used the Horn-Schunck method to estimate the horizontal and vertical motion components of the image:

* `u` — horizontal flow
* `v` — vertical flow

The main optical flow constraint equation is:

$$
I_xu + I_yv + I_t = 0
$$

where:

* `Ix` is the image gradient in the x direction
* `Iy` is the image gradient in the y direction
* `It` is the temporal gradient

## Horn-Schunck Method

Horn-Schunck estimates a dense optical flow field by combining the optical flow constraint with a smoothness assumption. The flow is calculated iteratively, with neighboring pixels influencing each other.

In this implementation:

* Smoothness parameter (`alpha`) = 4
* Number of iterations = 100
* Flow vectors are displayed using a quiver plot

## Project Structure

```text
horn-schunck-optical-flow/
├── horn_schunck.m
├── images/
│   ├── car_frame1.png
│   └── car_frame2.png
└── results/
    ├── first_frame.png
    ├── optical_flow.png
    └── optical_flow_on_image.png
```

## Results

The script produces three figures:

1. The first input frame
2. The estimated optical flow field
3. The optical flow shown over the original image

## Results

### First Frame

![First Frame](results/first_frame.png)

### Optical Flow

![Optical Flow](results/optical_flow.png)

### Optical Flow on Image

![Optical Flow on Image](results/optical_flow_on_image.png)

The resulting maximum flow values in this example were:

```text
Maximum horizontal flow (u): 75.8211
Maximum vertical flow (v): 52.822
```

The arrows show the estimated direction and magnitude of apparent pixel motion.

## Tools

* MATLAB
* Image Processing
* Computer Vision
* Horn-Schunck Optical Flow

## About

This was a university class/lab project that I worked on to understand optical flow and the Horn-Schunck method in practice.
