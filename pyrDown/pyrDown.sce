// Function is working with the Scilab 5.5.2 and IPD (Image Processing Design Toolbox) 8.3.2-0. Author: Szymon Molinski. Feel free to use!

function resizedImage = pyrDown(image)
    
    // Blurring an image
    
    kernel_16 = (1/256) * [1 4 6 4 1; 4 16 24 16 4; 6 24 36 24 6; 4 16 24 16 4; 1 4 6 4 1]; 
    // magic numbers -> kernel provided in the OpenVX library 
    // for the Gaussian Image Pyramid function 
    // https://www.khronos.org/registry/vx/specs/1.0.1/html/d0/d15/group__group__vision__function__gaussian__pyramid.html
    
    i = conv2(image, kernel_16, "same")
    
    // Removing even-numbered rows and columns
    
    is = size(i); // i - image matrix
    if is(1) < 8 | is(2) < 8 then
        error('Image is too small to end the operation')
        abort
    else
        
        x = is(1);
    
        y = is(2);
    
        j = [2:2:x] // vector for even-numbered rows - x is the dimension 1 from the image
        i(j,:) = [] 

    
        k = [2:2:y] // vector for even-numbered columns - y is the dimension 2 from the image
        i(:,k) = [] 
        
        resizedImage = round(i)
        
    end
    
endfunction
