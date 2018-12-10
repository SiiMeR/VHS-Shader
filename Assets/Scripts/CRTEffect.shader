// based on https://github.com/libretro/common-shaders/blob/master/crt/shaders/crt-easymode.cg
Shader "Hidden/CRTEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _HorizontalSharpness ("Horizontal Sharpness", Range(0.0, 1.0)) = 0.5
        _VerticalSharpness ("Vertical Sharpness", Range(0.0, 1.0)) = 1.0
        _MaskStrength ("Mask Strength", Range(0.0, 1.0)) = 0.3
        _MaskDotWidth ("Mask Dot Width", Range(1.0, 100.0)) = 1.0
        _MaskDotHeight ("Mask Dot Height", Range(1.0, 100.0)) = 1.0
        _MaskStagger ("Mask Stagger", Range(0.0, 100.0)) = 0.0
        _MaskSize ("Mask Size", Range(0.0, 100.0)) = 0.0
        _ScanlineStrength ("Scanline Strength", Range(0.0, 1.0)) = 1.0
        _ScanlineBeamWidthMin ("Scanline Beam Width Min.", Range(0.5, 5.0)) = 1.5
        _ScanlineBeamWidthMax ("Scanline Beam Width Max.", Range(0.5, 5.0)) = 1.5
        _ScanlineBrightMin ("Scanline Brightness Min.", Range(0.0, 1.0)) = 0.35
        _ScanlineBrightMax ("Scanline Brightness Max.", Range(0.0, 1.0)) = 0.65
        _ScanlineCutoff ("Scanline Cutoff", Range(1.0, 1000.0)) = 400.0
        _GammaInput ("Gamma Input", Range(0.1, 5.0)) = 2.0
        _GammaOutput ("Gamma Output", Range(0.1, 5.0)) = 1.8
        _BrightBoost ("Brightness Boost", Range(1.0, 2.0)) = 1.2
        _Dilation ("Dilation", Range(0.0, 1.0)) = 1.0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define FIX(c) max(abs(c), 1e-5)
            #define PI 3.141592653689
            #define TEX2D(c) dilate(SamplePoint(tex, c))
            #define mod(x,y) (x - y * trunc(x/y))
            #define ENABLE_LANCZOS 1
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : COMPAT_POS;
                float2 texCoord : TEXCOORD0;
                float4 color : COLOR;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            uniform float   _HorizontalSharpness, 
                            _VerticalSharpness, 
                            _MaskStrength, 
                            _MaskDotWidth, 
                            _MaskDotHeight, 
                            _MaskStagger, 
                            _MaskSize, 
                            _ScanlineStrength, 
                            _ScanlineBeamWidthMin, 
                            _ScanlineBeamWidthMax, 
                            _ScanlineBrightMin, 
                            _ScanlineBrightMax, 
                            _ScanlineCutoff, 
                            _GammaInput, 
                            _GammaOutput,
                            _BrightBoost,
                            _Dilation;
                            
            uniform sampler2D _MainTex;                             

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // just invert the colors
                col.rgb = 1 * col.rgb;
                return col;
            }
            ENDCG
        }
    }
}
