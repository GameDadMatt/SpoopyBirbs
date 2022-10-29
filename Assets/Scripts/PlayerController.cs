using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Player
{
    public class PlayerController : MonoBehaviour
    {
        public static PlayerController instance;
        public float speed = 5f;
        private float speedMod = 1f;
        private bool slowed = false;
        private BirbAppearance birb;
        private Animator animator;
        private PlayerInput input;
        private Rigidbody rbody;
        private Vector3 move;
        public float limboCD = 3f;

        private void Awake()
        {
            if(instance == null)
            {
                instance = this;
            }

            rbody = GetComponent<Rigidbody>();
            input = new PlayerInput();
            animator = GetComponentInChildren<Animator>();
            birb = GetComponentInChildren<BirbAppearance>();
        }

        private void OnEnable()
        {
            input.BirbActions.Enable();
        }

        private void OnDisable()
        {
            input.BirbActions.Disable();
        }

        private void Update()
        {
            if (input.BirbActions.Limbo.WasPressedThisFrame())
            {
                LimboFlip();
            }
        }

        private void OnTriggerEnter(Collider other)
        {
            if (other.transform.tag == "Barrier" && GlobalVariables.instance.Limbo)
            {
                speedMod = 0.5f;
                slowed = true;
            }
        }

        private void OnTriggerStay(Collider other)
        {
            if (other.transform.tag == "Barrier" && GlobalVariables.instance.Limbo && !slowed)
            {
                speedMod = 0.5f;
                slowed = true;
            }
        }

        private void OnTriggerExit(Collider other)
        {
            {
                if (other.transform.tag == "Barrier" && GlobalVariables.instance.Limbo)
                {
                    speedMod = 1f;
                    slowed = false;
                }
            }
        }

        private void FixedUpdate()
        {
            Vector2 i = input.BirbActions.Move.ReadValue<Vector2>();
            move = new Vector3(i.x, 0, i.y);
            rbody.velocity = move * (speed * speedMod);

            if(rbody.velocity != Vector3.zero && !animator.GetBool("Walking"))
            {
                animator.SetBool("Walking", true);
            }
            else if(rbody.velocity == Vector3.zero && animator.GetBool("Walking"))
            {
                animator.SetBool("Walking", false);
            }
        }

        private void LimboFlip()
        {
            if (!slowed)
            {
                GlobalVariables.instance.FlipLimbo();
                if (GlobalVariables.instance.Limbo)
                {
                    birb.ChangeEmotion(BirbEmotion.PlayerGhost);
                }
                else
                {
                    birb.ChangeEmotion(BirbEmotion.PlayerNeutral);
                }
            }            
        }
    }
}