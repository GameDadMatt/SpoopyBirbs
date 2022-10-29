////////////////////////////////////////////
// CameraFilterPack - by VETASOFT 2020 /////
////////////////////////////////////////////

using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
[AddComponentMenu ("Camera Filter Pack/Blur/Regular")]
public class CameraFilterPack_Blur_Regular : MonoBehaviour {
	#region Variables
	public Shader SCShader;
	private float TimeX = 1.0f;
	 
	private Material SCMaterial;
	[Range(1, 16)] public int Level = 4;
	public Vector2 Distance = new Vector2(30.0f,0.0f);


	#endregion
	
	#region Properties
	Material material
	{
		get
		{
			if(SCMaterial == null)
			{
				SCMaterial = new Material(SCShader);
				SCMaterial.hideFlags = HideFlags.HideAndDontSave;	
			}
			return SCMaterial;
		}
	}
	#endregion
	void Start () 
	{
		SCShader = Shader.Find("CameraFilterPack/Blur_Regular");

		if(!SystemInfo.supportsImageEffects)
		{
			enabled = false;
			return;
		}
	}
	
	void OnRenderImage (RenderTexture sourceTexture, RenderTexture destTexture)
	{
		if(SCShader != null)
		{
			TimeX+=Time.deltaTime;
			if (TimeX>100)  TimeX=0;
			material.SetFloat("_TimeX", TimeX);
			material.SetFloat("_Level", Level);
			material.SetVector("_Distance", Distance);
			material.SetVector("_ScreenResolution",new Vector4(sourceTexture.width,sourceTexture.height,0.0f,0.0f));
			Graphics.Blit(sourceTexture, destTexture, material);
		}
		else
		{
			Graphics.Blit(sourceTexture, destTexture);	
		}
		
		
	}
	
	 
	void Update () 
	{
		#if UNITY_EDITOR
		if (Application.isPlaying!=true)
		{
			SCShader = Shader.Find("CameraFilterPack/Blur_Regular");

		}
		#endif

	}
	
	void OnDisable ()
	{
		if(SCMaterial)
		{
			DestroyImmediate(SCMaterial);	
		}
		
	}
	
	
}