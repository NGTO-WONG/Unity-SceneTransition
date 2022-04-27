
using System.Globalization;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using Unity.VisualScripting;
using UnityEngine.SceneManagement;

public class Interstellar : MonoBehaviour
{
    [SerializeField] Button _button;
    [SerializeField] private GameObject transition;
    private static readonly int Value = Shader.PropertyToID("_Value");

    private Material _material;
    private void Start()
    {
        _button.onClick.AddListener(Call);
        _material = transition.GetComponent<Image>().material;
        _material.SetFloat(Value,18.62f);
    }

    private async void Call()
    {
        var parent = _button.transform.parent;
        DontDestroyOnLoad(parent);
        transition.GameObject().SetActive(true);
        _button.GameObject().SetActive(false);
        var tween3=_material.DOFloat(30f, Value, 15f);
        tween3.SetEase(Ease.InOutExpo);
        tween3.onComplete += () => { SceneLoader.GetInstance().animationComplete = true; };
        await SceneLoader.GetInstance().LoadSceneAsync("Nothing");
        transition.GameObject().SetActive(false);

    }
}
