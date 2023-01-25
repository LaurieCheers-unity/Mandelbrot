Shader "Unlit/Mandelbrot"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float2 z = float2(0, 0);
				float steps = 0;
				while (z.x * z.x + z.y * z.y < 4 && steps < 1)
				{
					z = float2(z.x * z.x + i.uv.x - z.y * z.y, 2 * z.x * z.y + i.uv.y);
					steps += 0.005;
				}
				fixed4 col = tex2D(_MainTex, float2(steps, 0));
				// apply fog
               // UNITY_APPLY_FOG(i.fogCoord, col);
				return col;// fixed4(steps, steps, steps, 1);
            }
            ENDCG
        }
    }
}
