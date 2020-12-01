//
//  StackBlur.metal
//  VideoPlayer
//
//  Created by JaehyeonPark on 2020/11/27.
//

#include <metal_stdlib>
using namespace metal;

#include <CoreImage/CoreImage.h>


namespace coreimage {
 
    
     extern "C" float4 horizontalStackBlurKernel(sampler image, float radius, destination dest){

        float total_weight = pow(radius + 1, 2);
        float4 sum = image.sample(image.transform(dest.coord())) * (radius + 1);

        for (int i=1; i<=radius; i++) {
            float weight = (radius + 1) - i;
            sum += image.sample(image.transform(dest.coord() + float2(i, 0)))  * weight;
            sum += image.sample(image.transform(dest.coord() + float2(-i, 0))) * weight;
        }

        return sum / total_weight;
         
    }
    
    
    extern "C" float4 verticalStackBlurKernel(sampler image, float radius, destination dest){

        float total_weight = pow(radius + 1, 2);
        float4 sum = image.sample(image.transform(dest.coord())) * (radius + 1);
       
        for (int i=1; i<=radius; i++) {
            float weight = (radius + 1) - i;
            sum += image.sample(image.transform(dest.coord() + float2(0, i)))  * weight;
            sum += image.sample(image.transform(dest.coord() + float2(0, -i))) * weight;
        }
       
        return sum / total_weight;
        
   }
    
    
}
