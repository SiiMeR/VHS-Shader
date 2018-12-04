Shader "Hidden/VHSPostProcessEffect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_VHSTex ("Base (RGB)", 2D) = "white" {}
	}

	SubShader {
		Pass {
			ZTest Always Cull Off ZWrite Off
			Fog { Mode off }
					
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest 
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _VHSTex;
			uniform sampler2D _VideoTex;
			
			uniform float _bleedIntensity,
			              _bleedShiftR,
			              _bleedShiftG,
			              _bleedShiftB;
			
			
			float _yScanline;
			float _xScanline;
 
            min16float rand(float2 co)
            {
                min16float a = 12.9898;
                min16float b = 78.233;
                min16float c = 43758.5453;
                min16float dt= dot(co.xy ,float2(a,b));
                min16float sn= fmod(dt,3.14);
                return frac(sin(sn) * c);
            }
            
			fixed4 frag (v2f_img i) : COLOR
			{

				fixed4 vhs = tex2D (_VHSTex, i.uv);
				
				float dx = 1-abs(distance(i.uv.y, _xScanline));
				float dy = 1-abs(distance(i.uv.y, _yScanline));
				
				//float x = ((int)(i.uv.x*320))/320.0;
				dy = ((int)(dy*15))/15.0;
				dy = dy;
				i.uv.x += dy * 0.025 + rand(float3(dy,dy,dy)).r/500;//0.025;
				
				float white = (vhs.r+vhs.g+vhs.b)/3;
				
				if(dx > 0.99)
					i.uv.y = _xScanline;
				i.uv.y = step(0.99, dy) * (_yScanline) + step(dy, 0.99) * i.uv.y;
				
				i.uv.x = i.uv.x % 1;
				i.uv.y = i.uv.y % 1;
				
				fixed4 c = tex2D (_MainTex, i.uv);
				
				
				float bleedG = tex2D(_MainTex, i.uv + float2(_bleedShiftG, 0)).g;
                float bleedR = tex2D(_MainTex, i.uv + float2(_bleedShiftR + 0.01*rand(frac(_SinTime.y)), 0)).r;
                float bleedB = tex2D(_MainTex, i.uv + float2(_bleedShiftB, -0.01)).b;
                
			    float3 bleed = float3(bleedR, bleedG, bleedB);
                bleed *= _bleedIntensity;
				
				
				if(bleed.r > 0.1){
					vhs += fixed4(bleed.r * _xScanline, 0, 0, 0);
				}
				
				
				float x = ((int)(i.uv.x*320))/320.0;
				float y = ((int)(i.uv.y*240))/240.0;
				
			//	c += rand(float3(x, y, _xScanline)) * _xScanline / 5;
				
				//c /=2;
				//return c;
				c.rgb += bleed.rgb;
				return c;
			}
			ENDCG
		}
	}
Fallback off
}