using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using Player;

public class CameraController : MonoBehaviour
{
    public static CameraController instance;
    public float camZoom = 1f;
    private CinemachineVirtualCamera camera;
    private float fov;
    private Vector3 cameraPos;
    private CameraFilterPack_Blur_Noise noise;
    private CameraFilterPack_Color_BrightContrastSaturation limbo;

    private void Awake()
    {
        if(instance == null)
        {
            instance = this;
        }
        camera = GetComponent<CinemachineVirtualCamera>();
        fov = camera.m_Lens.FieldOfView;
        cameraPos = camera.transform.localPosition;
        noise = Camera.main.GetComponent<CameraFilterPack_Blur_Noise>();
        limbo = Camera.main.GetComponent<CameraFilterPack_Color_BrightContrastSaturation>();
        limbo.enabled = false;
    }

    private void Update()
    {
        if (GlobalVariables.instance.Limbo)
        {
            camera.m_Lens.FieldOfView = fov + CalcDist;
            Vector3 newCamPos = cameraPos;
            newCamPos.z = cameraPos.z - (CalcDist * camZoom);
            camera.transform.localPosition = newCamPos;
            noise.Distance = NoiseAmount;
        }
    }

    public void ToggleLimbo(bool l)
    {
        limbo.enabled = l;
        if (!l)
        {
            camera.m_Lens.FieldOfView = fov;
            camera.transform.localPosition = cameraPos;
            noise.Distance = Vector2.zero;
        }        
    }

    private Vector2 NoiseAmount
    {
        get
        {
            return new Vector2(CalcDist, CalcDist);
        }
    }

    private float CalcDist
    {
        get
        {
            float dist = ((CurrentMonsterDistance / GlobalVariables.instance.followDistance) - 1) * -1;
            dist *= 30;
            return dist;
        }
    }

    private float CurrentMonsterDistance
    {
        get
        {
            return Vector3.Distance(PlayerController.instance.transform.position, MonsterController.instance.transform.position);
        }        
    }
}
