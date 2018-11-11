using UnityEngine;

public class CameraMovement : MonoBehaviour
{

    [SerializeField] private float _MoveSpeed = 10;
    [SerializeField] private bool _LockCursor = true;
    [SerializeField] private float _XSensitivity = 1;
    [SerializeField] private float _YSensitivity = 1;

    private bool _isCursorLocked;
    private Camera _mainCamera;
	
    // Use this for initialization
    private void Start ()
    {
        _mainCamera = GetComponentInChildren<Camera>();
    }
	
    // Update is called once per frame
    private void Update () {

		
        var yRot = Input.GetAxisRaw("Mouse X") * _XSensitivity;
        var xRot = Input.GetAxisRaw("Mouse Y") * _YSensitivity;
		
        var ms = _MoveSpeed;
		
        if (Input.GetKey(KeyCode.LeftShift))
        {
            ms *= 2;
        }

        transform.position += _mainCamera.transform.forward * ms * Input.GetAxis("Vertical") * Time.deltaTime;
        transform.position += _mainCamera.transform.right * ms * Input.GetAxis("Horizontal") * Time.deltaTime;

        transform.localRotation *= Quaternion.Euler (0f, yRot, 0f);
		
        _mainCamera.transform.localRotation *= Quaternion.Euler(-xRot, 0f, 0f);
		
        UpdateCursorLock();
    }
	
    //
    // CODE BELOW IS FROM UNITY STANDARD ASSETS MouseLook.cs
    //

    private void UpdateCursorLock()
    {
        //if the user set "lockCursor" we check & properly lock the cursors
        if (_LockCursor)
            InternalLockUpdate();
    }

    private void InternalLockUpdate()
    {
        if(Input.GetKeyUp(KeyCode.Escape))
        {
            _isCursorLocked = false;
        }
        else if(Input.GetMouseButtonUp(0))
        {
            _isCursorLocked = true;
        }

        if (_isCursorLocked)
        {
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }
        else
        {
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;
        }
    }
}