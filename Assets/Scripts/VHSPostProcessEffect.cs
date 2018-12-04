using System;
using UnityEngine;
using System.Collections;
using System.Linq;
using UnityEngine.Video;
using Random = UnityEngine.Random;

//[ExecuteInEditMode]
[RequireComponent (typeof(Camera))]
public class VHSPostProcessEffect : MonoBehaviour {
    
    public Shader shader;
    public VideoClip VHS;
    public VideoClip Intro;
    public VideoPlayer Screen;
    public RenderTextureFormat renderTextureFormat = RenderTextureFormat.Default;
    
    
    public float BleedIntensity;
    
    [Range(-.2f, .2f)]
    public float BleedRShift = +0.01f;
    [Range(-.2f, .2f)]
    public float BleedGShift = 0f;
    [Range(-.2f, .2f)]
    public float BleedBShift = -0.02f;

    [Range(1,16)]
    public int renderResolutionDivision = 4;
    
    private Material _material;
    public Material Material {
        get {
            if (_material == null) {
                _material = new Material(shader);
                _material.hideFlags = HideFlags.HideAndDontSave;
            }
            return _material;
        } 
    }

    private float _yScanline, _xScanline;
    private VideoPlayer _videoPlayer;
    public void Start()
    {
        Screen.clip = Intro;
        
        
        Screen.isLooping = true;

        Screen.sendFrameReadyEvents = true;

        Screen.Play();

   
//        VHS.isLooping = true;
//        VHS.Play();
        //m = new Material(shader);
        //m.SetTexture("_VHSTex", VHS);
        //m.hideFlags = HideFlags.DontSave;
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {

        SetShaderVariables();

        _yScanline += Time.deltaTime * 0.01f;
        _xScanline -= Time.deltaTime * 0.1f;

        if(_yScanline >= 1)
        {
            _yScanline = Random.value;
        }
        if(_xScanline <= 0 || Random.value < 0.05){
            _xScanline = Random.value;
        }
        
        Material.SetFloat("_yScanline", _yScanline);
        Material.SetFloat("_xScanline", _xScanline);
        
        var renderTexture = RenderTexture.GetTemporary(source.width/renderResolutionDivision, source.height/renderResolutionDivision, 1, renderTextureFormat);
        Graphics.Blit(source, renderTexture);
        
        Graphics.Blit(renderTexture, destination, Material);
        
        RenderTexture.ReleaseTemporary(renderTexture);
    }

    private void SetShaderVariables()
    {
        Material.SetFloat("_bleedIntensity", BleedIntensity);
        Material.SetFloat("_bleedShiftR", BleedRShift);
        Material.SetFloat("_bleedShiftG", BleedGShift);
        Material.SetFloat("_bleedShiftB", BleedBShift);
    }
}