using UnityEngine;

[CreateAssetMenu(fileName = "BirbTexture", menuName = "SpookyBirdGame / BirbTexture")]
public class BirbTexture : ScriptableObject
{
    public Texture texture;
    public BirbEmotion emotion;
}