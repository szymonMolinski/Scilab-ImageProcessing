// Functions are working with the Scilab 5.5.2 and IPD (Image Processing Design Toolbox) 8.3.2-0. Author: Szymon Molinski. Feel free to use!

function blurred_image = gaussianBlur(image, sigma, kernel_size)
    
    // Checking kernel_size
    
    if round(kernel_size/2) == (kernel_size/2) then
        
        error('Kernel Size must be odd number')
        abort
        
    else
        
        gaussKernel = createGaussianKernel(sigma, kernel_size)
        blurred_image = conv2(image, gaussKernel, "same")
        
    end
endfunction

function kernel2D = createGaussianKernel(s, k_size)
    
    // Creation of the base matrix 1
    
    kernelMat1 = zeros(k_size, k_size)
    
    w = -1*(floor(k_size/2))
    
    for i=1:1:k_size
        kernelMat1(:,i) = w
        w = w + 1
    end
    
    // Creation of the base matrix 2
    
    kernelMat2 = kernelMat1'
    
    // Creation of kernel
    
    kernelMatBase = (1/(2*%pi*s^2))*exp(-((kernelMat1.^2 + kernelMat2.^2)/(2*s^2))) // Equation based on the: https://www.wikiwand.com/en/Gaussian_blur
    kernel2D = kernelMatBase/sum(kernelMatBase) 
    
endfunction

