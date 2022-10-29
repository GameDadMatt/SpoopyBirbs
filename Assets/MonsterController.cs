using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Player;

public class MonsterController : MonoBehaviour
{
    public static MonsterController instance;
    public bool hunt = false;
    public float speed = 1f;
    private Rigidbody rbody;
    private Vector3 move;
    private Projector projection;

    private void Awake()
    {
        if(instance == null)
        {
            instance = this;
        }

        rbody = GetComponent<Rigidbody>();
        projection = GetComponentInChildren<Projector>();
        ToggleHunt(hunt);
    }

    private void FixedUpdate()
    {
        if (hunt)
        {
            move = PlayerController.instance.transform.position - transform.position;
            move = move.normalized;
            move.y = 0f;
            rbody.velocity = move.normalized * speed;
        }
        else
        {
            move = PlayerController.instance.transform.position;
            move.z -= GlobalVariables.instance.followDistance;
            move.y = 0f;
            transform.position = move;
        }
    }

    public void ToggleHunt(bool state)
    {
        hunt = state;
        projection.gameObject.SetActive(hunt);

        if (!hunt)
        {
            rbody.velocity = Vector3.zero;
        }
    }
}
