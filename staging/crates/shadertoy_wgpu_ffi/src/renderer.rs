use crate::Renderer;
use ffi_support::FfiStr;
use std::ptr;

/// Creates a new shadertoy renderer instance.
///
/// # Returns
///
/// Returns opaque pointer to renderer instance.
/// Caller is required to call [shadertoy_renderer_free](fn.shadertoy_renderer_free.html)
/// to properly free memory.
///
/// `NULL` pointer might be returned if the renderer creation had failed.
/// Caller can check [shadertoy_renderer_last_error_message](fn.shadertoy_renderer_last_error_message.html)
/// for error details.
#[no_mangle]
pub extern "C" fn shadertoy_renderer_new(json: FfiStr) -> *mut Renderer {
    match Renderer::new(&json.into_string()) {
        Ok(renderer) => Box::into_raw(Box::new(renderer)),
        Err(e) => {
            crate::errors::set_last_error(e);
            ptr::null_mut()
        }
    }
}

/// Frees renderer instance.
#[no_mangle]
pub unsafe extern "C" fn shadertoy_renderer_free(ptr: *mut Renderer) {
    if ptr.is_null() {
        return;
    }

    Box::from_raw(ptr);
}
