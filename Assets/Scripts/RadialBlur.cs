using UnityEngine;

/// <summary>
/// Attach it to the camera.
/// 
/// original code from: http://forum.unity3d.com/threads/radial-blur.31970/	
/// 
/// (c)2015 Kim, Hyoun Woo
/// </summary>
[ExecuteInEditMode]
public class RadialBlur : MonoBehaviour
{
    public Shader shader;

    public float blurStrength = 2.2f;
    public float blurWidth = 1.0f;

    private Material material = null;
    private bool isOpenGL;

    private Material GetMaterial()
    {
        if (material == null)
        {
            material = new Material(shader);
            material.hideFlags = HideFlags.HideAndDontSave;
        }
        return material;
    }

    void Start()
    {
        if (shader == null)
        {
            shader = Shader.Find("FX/RadialBlur");
        }
        isOpenGL = SystemInfo.graphicsDeviceVersion.StartsWith("OpenGL");
    }

    void OnRenderImage(RenderTexture source, RenderTexture dest)
    {
        //If we run in OpenGL mode, our UV coords are
        //not in 0-1 range, because of the texRECT sampler
        float ImageWidth = 1;
        float ImageHeight = 1;
        if (isOpenGL)
        {
            ImageWidth = source.width;
            ImageHeight = source.height;
        }

        GetMaterial().SetFloat("_BlurStrength", blurStrength);
        GetMaterial().SetFloat("_BlurWidth", blurWidth);
        GetMaterial().SetFloat("_imgHeight", ImageWidth);
        GetMaterial().SetFloat("_imgWidth", ImageHeight);

        Graphics.Blit(source, dest, GetMaterial());
    }
}