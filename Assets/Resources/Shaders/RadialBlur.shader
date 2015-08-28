///////////////////////////////////////////////////////////////////////////////
//  RadialBlur.shader
//
//  Upgrade NOTE: replaced 'samplerRECT' with 'sampler2D'
//  Upgrade NOTE: replaced 'texRECT' with 'tex2D'
//
//	original code from: http://forum.unity3d.com/threads/radial-blur.31970/	
// 
//  (c)2015 Kim, Hyoun Woo
///////////////////////////////////////////////////////////////////////////////

Shader "FX/RadialBlur"
{
    Properties 
    {
        _MainTex ("Input", RECT) = "white" {}
        _BlurStrength ("", Float) = 0.5
        _BlurWidth ("", Float) = 0.5
    }

    SubShader 
    {
        Pass 
        {
            ZTest Always Cull Off ZWrite Off
            Fog { Mode off }
       
            CGPROGRAM
   
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
 
            #include "UnityCG.cginc"
 
            uniform sampler2D _MainTex;
            uniform half4 _MainTex_TexelSize;
            uniform half _BlurStrength;
            uniform half _BlurWidth;
            uniform half _imgWidth;
            uniform half _imgHeight;
 
            half4 frag (v2f_img i) : COLOR 
            {
                half4 color = tex2D(_MainTex, i.uv);
       
                // some sample positions
                half samples[10];
                samples[0] = -0.08;
                samples[1] = -0.05;
                samples[2] = -0.03;
                samples[3] = -0.02;
                samples[4] = -0.01;
                samples[5] =  0.01;
                samples[6] =  0.02;
                samples[7] =  0.03;
                samples[8] =  0.05;
                samples[9] =  0.08;
       
                //vector to the middle of the screen
                half2 dir = 0.5 * half2(_imgHeight,_imgWidth) - i.uv;
       
                //distance to center
                half dist = sqrt(dir.x*dir.x + dir.y*dir.y);
       
                //normalize direction
                dir = dir/dist;
       
                //additional samples towards center of screen
                half4 sum = color;
                for(int n = 0; n < 10; n++)
                {
                    sum += tex2D(_MainTex, i.uv + dir * samples[n] * _BlurWidth * _imgWidth);
                }
       
                //eleven samples...
                sum *= 1.0/11.0;
       
                //weighten blur depending on distance to screen center
                /*
                half t = dist * _BlurStrength / _imgWidth;
                t = clamp(t, 0.0, 1.0);
                */		
                half t = saturate(dist * _BlurStrength);
       
                //blend original with blur
                return lerp(color, sum, t);
            }
            ENDCG
        }
    }
}