Shader "OCB/MOER"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("Normal", 2D) = "bump" {}
        _MOER("MOER", 2D) = "black" {}
        _Color("Albedo Tint Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _RMOE;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_RMOE;
            float2 uv_BumpMap;
        };

        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Albedo = c.rgb;
            o.Alpha = c.a;
            // Get the RMOE map and distribute channels
            fixed4 rmoe = tex2D(_RMOE, IN.uv_RMOE);
            // Not 100% sure if this is the correct setup?
            o.Emission = rmoe.b * c.rgb;
            // Metallic is in red channel
            o.Metallic = rmoe.r;
            // We have roughness in red channel
            o.Smoothness = 1 - rmoe.a;
            // Occlusion is in blue channel
            o.Occlusion = rmoe.g;
        }
        ENDCG
    }
    FallBack "Lit"
}
