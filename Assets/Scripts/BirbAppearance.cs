using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BirbAppearance : MonoBehaviour
{
    private Material mat;

    private void Awake()
    {
        mat = GetComponent<Renderer>().material;
    }

    public void ChangeEmotion(BirbEmotion emotion)
    {
        mat.SetTexture("_MainTex", GlobalVariables.instance.BirbTexture(emotion));
    }    
}
