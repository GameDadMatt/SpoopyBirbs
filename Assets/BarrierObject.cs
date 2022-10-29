using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BarrierObject : MonoBehaviour
{
    public Material real;
    public Material limbo;
    private BoxCollider barrier;
    private Projector projector;

    private void Awake()
    {
        barrier = GetComponent<BoxCollider>();
        projector = GetComponentInChildren<Projector>();
        LimboState(false);
    }

    private void OnEnable()
    {
        GlobalVariables.instance.OnLimboChange += LimboState;
    }

    private void OnDisable()
    {
        GlobalVariables.instance.OnLimboChange -= LimboState;
    }

    private void LimboState(bool l)
    {
        if (l)
        {
            SetMaterial(limbo);
            barrier.enabled = false;
            projector.enabled = true;
        }
        else
        {
            SetMaterial(real);
            barrier.enabled = true;
            projector.enabled = false;
        }
    }

    private void SetMaterial(Material m)
    {
        GetComponent<Renderer>().material = m;
    }
}
