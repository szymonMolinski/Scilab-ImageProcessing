clc
clear
xdel(winsid()) // Close all existing figures

// Scilab Computer Vision tutorial: drawing objects, geometrical analysis

scicv_Init();

function plot_mat(img, desc)
    figure()
    matplot(img)
    title(desc)
endfunction

// ----------> DRAWING OBJECTS <----------

// Canvas for drawing: use new_Mat(int rows, int cols, int type, const Scalar(0))

canvas_width = 500;
canvas_height = 200;
my_canvas = new_Mat(canvas_height, canvas_width, CV_8UC3, int(0)); // Remember to delete object after session

plot_mat(my_canvas, 'My canvas');

// Draw some figures on the canvas - ellipse

// Syntax for ellipse: ellipse(image, center, axes, angle, startAngle, endAngle, color, thickness, lineType, shift)
// Where:
// image - cv::Mat / image (canvas),
// center - int / center point of the ellipse in the for of [x, y] coordinates,
// axes - int / half of the major and half of the minor axis of the ellipse as the pair of points [half_ax_major, half_ax_minor],
// angle - double / ellipse rotation angle in degreees in anti-clockwise direction,
// startAngle - double / starting angle of the elliptic arc in degrees in clockwise direction from major axis,
// endAngle - double / ending angle of the elliptic arc in degrees in clockwise direction from major axis,
// if startAngle == 0 and endAngle == 360 then we have a full ellipse
// color - color as the BGR values [B, G, R],
// thickness - thickness of the ellipse arc outline, if positive. Otherwise, this indicates that a filled ellipse sector is to be drawn. The default value is 1,
// lineType - type of the ellipse boundary. The default type is 8 (8-connected line), it should be also 4 (4-connected line),
// shift - number of fractional bits in the coordinates of the center and values of axes. Default value is 0.

my_canvas_center_w = int(canvas_width / 4);
my_canvas_center_h = int(canvas_height / 2);
major_axis = int(canvas_width / 10);
minor_axis = int(canvas_height / 12);
ellipse(my_canvas, [my_canvas_center_w, my_canvas_center_h], [major_axis, minor_axis], ...
        30, 0, 360, [255, 0, 0], -1, 8);
        
plot_mat(my_canvas, 'My canvas with blue ellipse in the center');

// Draw some figures on the canvas - rectangle

// Syntax for rectangle: rectangle(image, up-left point, down-right point, color, thickness, lineType, shift)
// Where:
// image - cv::Mat / image (canvas),
// up-left point - int / vertex of the rectangle as the [x1, y1] coordinates,
// down-right point - int / vertex opoosite to the up-left point [x2, y2]
// color - color as the BGR values [B, G, R],
// thickness - thickness of the rectangle outline, if positive. Otherwise, this indicates that a filled rectangle sector is to be drawn. The default value is 1,
// lineType - type of the rectangle boundary. The default type is 8 (8-connected line), it should be also 4 (4-connected line) or CV_AA (antialiased line),
// shift - number of fractional bits in the point coordinates. Default value is 0.

rect_x = 20;
rect_y = 10;
dx = 45;
dy = 25;
rectangle(my_canvas, [rect_x, rect_y], [rect_x+dx, rect_y+dy], [100, 255, 25], -1, 0);

plot_mat(my_canvas, 'My canvas with blue ellipse and green rectangle');

// Add text to the canvas

// Syntax for text placement: putText(image, text, start_point, font, font_scale, color, thickness, lineType, bottomLeftOrigin)
// Where:
// image - cv::Mat / image (canvas),
// text - string,
// start_point - int / bottom-left corner of the text string in the image [x, y] -> PAY ATTENTION to the bottomLeftOrigin parameter, because it is also related to the text position,
// font - font type. FONT_HERSHEY_SIMPLEX, FONT_HERSHEY_PLAIN, FONT_HERSHEY_DUPLEX, FONT_HERSHEY_COMPLEX, FONT_HERSHEY_TRIPLEX, FONT_HERSHEY_COMPLEX_SMALL, FONT_HERSHEY_SCRIPT_SIMPLEX, FONT_HERSHEY_SCRIPT_COMPLEX,
// font_scale - double / font scale factor multiplied by the font=specific base size,
// color - color as the BGR values [B, G, R],
// thickness - thickness of the text outline, if positive. The default value is 1,
// lineType - type of the text lines. The default type is 8 (8-connected line), it should be also 4 (4-connected line) or CV_AA (antialiased line),
// bottomLeftOrigin - bool / true - text origin point is calculated from the bottom-left corner. False - text origin point is calculated from the top-left corner.

text_orig_x = canvas_width - 250;
text_orig_y = canvas_height - 50;
putText(my_canvas, 'Scilab', [text_orig_x, text_orig_y], FONT_HERSHEY_SCRIPT_COMPLEX, 2, [0, 120, 240], 2, 8, %f);

plot_mat(my_canvas, 'My canvas with blue ellipse, green rectangle and orange text');

// ----------> GEOMETRICAL ANALYSIS <----------

// At this part of tutorial we will use few geometrical descriptors and compare objects in the image by their geometrical properties. The first thing to do is the object detection then objects are putted into a list and geometrical analysis is performed

// All needed steps:
// 1) Convert image to intensity values (from RGB),
// 2) Detect edges, in this example we will use Canny edge detection,
// 3) Find contours,
// 4) Cut image samples with detected objects,
// 5) Perform geometrical analysis

// 1) Conversion from RGB to gray scale.
// Syntax: output image = cvtColor(input image, coversion type, number of channels)
// Where:
// output image - cv::Mat / image of the same size and (usually) depth as the input image
// input image - cv::Mat / image of type 8 bit unsigned, 16 bit unsigned or single-precision floating point
// conversion type - color conversion code. For changing RGB to Gray it is CV_BGR2GRAY. For changing Gray to RGB it is CV_GRAY2BGR
// number of channels - by default this parameter is set to 0 and number of the channels is derived from input image and conversion type

gray_image = cvtColor(my_canvas, CV_BGR2GRAY);
plot_mat(gray_image, 'Gray canvas');

// 2) Edge detection
// Syntax: output image = Canny(input image, threshold bottom limit, threshold top limit, kernel size, L2gradient)
// Where:
// output image - cv::Mat / image of the edges,
// input image - cv::Mat / 1-channel, 8 bit, gray image,
// threshold bottom limit - objects with intensity value below this threshold limit will be discarded and treated as the edge,
// threshold top limit - objects with intensity values above this limit are considered as the edges. Objects between bottom and top limits are treated as the edge only if they are connected to these above the top limit,
// kernel size - Sobel operator Kernel size (it must be odd value, usally 3 or 5)
// L2gradient - if true, calculations are more accurate but computationally more expensive. Default is false.

thresh = 10;
img_canny = Canny(gray_image, thresh, thresh*3, 3);
element = getStructuringElement(MORPH_RECT, [3 3]);
img_canny = dilate(img_canny, element);
plot_mat(img_canny, 'Edges detected by Canny detector')

// 3) Find contours
// Syntax: [output image, contours list] = findContours(edges image, retrieval mode, approximation method, offset)
// Where:
// output image - cv::Mat / image of the contours,
// contours list - cv::VecPoints / list of contours,
// edges image - cv::Mat / image of edges (usually it is the output from the Canny detector),
// retrieval mode - parameter which sets types of the contours to retrieve:
// a) CV_RETR_EXTERNAL: returns only the outer contours;
// b) CV_RETR_LIST: returns all the contours;
// c) CV_RETR_CCOMP: returns a two level hierarchy in which the top level contains the outer boundaries of components, and the second level contains the holes; 
// d) CV_RETR_TREE: returns full hierarchy of contours,

// approximation method - contour approximation:
// a) CV_CHAIN_APPROX_NONE: stores all the contour points;
// b) CV_CHAIN_APPROX_SIMPLE: stores only end points of (horizontal/vertical/diagonal) segments;
// c) CV_CHAIN_APPROX_TC89_L1, CV_CHAIN_APPROX_TC89_KCOS: used the the Tech-Chin algorithm to store points,

// offset - optional offset by which every contour point is shifted (default [0, 0]).

// In this tutorial we will use only outer contours (CV_RETR_EXTERNAL) and the end points of contours (CV_CHAIN_APPROX_SIMPLE)

[img_contours, hierarchy] = findContours(img_canny,CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE, [0,0]);

plot_mat(img_contours, 'Image contours')


    
    disp(typeof(img_contours(2)));
    extracted_points = img_contours(:);
    plot_mat(extracted_points, ' punkty ')
    //[contours_poly(i)] = approxPolyDP(img_contours(i), 3.0, %t );


delete_Mat(my_canvas)
delete_Mat(gray_image)
delete_Mat(img_canny)
//delete_Mat(img_contours)

