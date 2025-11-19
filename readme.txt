Running arguments
------------------

The executable file takes 2 arguments:
- 1st argument represents the number of threads that will be created when rendering MANDELBROT/Julia fractals.
  The parameter should not be greater than CPU*4.
  By default, there are CPU-2 threads for CPU>2 and max CPU*4.
  The whole idea to have so much threads is that pixels outside the stable area are drawn first in threads and there are too few threads remaining to compute stable area pixels => we wish for more threads (ideally Core number) to compute this area and speed up things.
- the second parameter is boolean (0=false, 1=true) to show/hide the second form, used to save huge pictures (up to x35 zoom).

How to use the software
------------------------

The software starts by default with:
- rendering the Mandelbrot set;
- using 200 iterations to establish the divergence (both Mandelbrot and Julia)

The c value for Mandelbrot runs between (-2,-2) -> (2,2) initially.
The c value for Julia is set by default at (-0.7, 0.27)
If you do not understand these parameters, read more on Wikipedia.

The default image size is 1000x1000 pixels.

Selecting Mandelbrot/Julia and clicking on Plot will render Mandelbrot/Julia with the default values stated above.
----------

Modifying the divergence iterations

Mandelbrot set:

A number of things will change:

- processing speed: the higher the iterations selected, the more time spent on deciding if the stable set is achieved. Goes slower with the form size.
- the palette changes, it is dependent on the number of iterations. Nice colors obtained at 2060, 32000, 2000000 iterations. Try other values that suit your taste.

Julia set:

- processing speed depends very much on the Form/image size.
- modifying iterations also changes palette. Not the same palette as Mandelbrot set. 

-----
Zooming 

Both Mandelbrot and Julia may be zoomed, up to huge numbers until pixelization occurs. Billion times for Mandebrot, hundreds of billion times for Julia. This is a limitation of floating point calculus in Lazarus/my algorithm.

To zoom, press SHIFT and select a rectangle with your mouse. Upon releasing the left mouse button, the selected area will zoom and will re-render with the selected area.

-------
Linking Mandelbrot and Julia

Mandelbrot and Julia sets are linked.
Right clicking on a Mandelbrot point will generate the corresponding Julia set.
Right clicking on the Julia set will show again the corresponding Mandelbrot image, the last rendered one.
Play with this feature to see its usage.

---------------
Saving (high-resolution) images

If the zoom selector is 1, the image saved will be the one seen on the screen.

It is possible to save high resolution images, by modifying the zoom selector (1->35).
At values >30, depending on the original resolution, it is possible to generate images so large that no image viewer will be able to read. Also the files may be very large (I have achieved 5GB file sizes in .BMP format) so be aware and play with this feature.

Computation time depends on your processor and the number of threads the program has been started with. It may take from hours to days to render the whole bitmap and save it. Good CPUs and SSD usage is strongly suggested for zooms >10.

-------------
Being informed of what happens

On the right side of the screen, a number of parameters are displayed while moving the mouse over images (both Mandelbrot and Julia). C numbers, pixels, zoom etc. These are self-explainable and they pertain to either the classic theory (c) or the image itself (pixels).

C variables may have LOTS of fraction digits, which cannot be displayed entirely, so only a number of fraction digits are displayed, but all digits are displayed if you hover with the mouse over the values.

Those values not displaying this hint could be displayed entirely and thus the hint was made obsolete/not displayed.

---

Multithreading, again

It is nice to spawn threads, lots of it.
And then, close them in a nicer manner, to avoid memory leaks.
Read docs on Google and see how they are created/destroyed in these source files.

The trick with these images created for Mandelbrot/Julia renders, is to divide the images in smaller ones, chinks of images, render them in parallel and finally assembling the whole stuff in the final image.
---------
Netflix is nice

but I like more coding and optimizing code in the mean time.
This is why I code instead. (not always though, I still need playtime)


