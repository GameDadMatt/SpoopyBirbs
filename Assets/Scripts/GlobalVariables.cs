using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public enum BirbEmotion { PlayerNeutral, PlayerSurprised, PlayerGhost, PlayerSad, PlayerSparkle, FriendNeutral, FriendScared, FriendAscending }

public class GlobalVariables : MonoBehaviour
{
    public static GlobalVariables instance;
    public List<BirbTexture> appearances;
    public float followDistance = 20f;
    private bool limbo = false;

    //Actions
    public event Action<bool> OnLimboChange;

    private void Awake()
    {
        if(instance == null)
        {
            instance = this;
        }
    }

    public Texture BirbTexture(BirbEmotion emotion)
    {
        foreach (BirbTexture bt in appearances)
        {
            if (bt.emotion == emotion)
            {
                return bt.texture;
            }
        }
        Debug.LogError("Unable to find texture for emotion " + emotion);
        return null;
    }

    public void FlipLimbo()
    {
        limbo = !limbo;
        MonsterController.instance.ToggleHunt(limbo);
        CameraController.instance.ToggleLimbo(limbo);
        OnLimboChange?.Invoke(limbo);
    }

    public bool Limbo
    {
        get
        {
            return limbo;
        }
    }
}
