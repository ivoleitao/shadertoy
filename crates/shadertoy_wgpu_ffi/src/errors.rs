use shadertoy_wgpu::Error;
use std::cell::RefCell;

thread_local! {
    static LAST_ERROR: RefCell<Option<Box<Error>>> = RefCell::new(None);
}

pub fn set_last_error(err: Error) {
    LAST_ERROR.with(|prev| {
        *prev.borrow_mut() = Some(Box::new(err));
    });
}

pub fn take_last_error() -> Option<Box<Error>> {
    LAST_ERROR.with(|prev| prev.borrow_mut().take())
}

pub fn clear_last_error() {
    let _ = take_last_error();
}

/// Checks if there was an error before.
///
/// # Returns
///
/// `0` if there was no error, `1` if error had occured.
#[no_mangle]
pub extern "C" fn shadertoy_renderer_have_last_error() -> i32 {
    LAST_ERROR.with(|prev| match *prev.borrow() {
        Some(_) => 1,
        None => 0,
    })
}

/// Gets error message length if any error had occurred.
///
/// # Returns
///
/// If there was no error before, returns `0`,
/// otherwise returns message length including trailing `\0`.
#[no_mangle]
pub extern "C" fn shadertoy_renderer_last_error_length() -> i32 {
    // TODO: Support Windows UTF-16 strings
    LAST_ERROR.with(|prev| match *prev.borrow() {
        Some(ref err) => err.to_string().len() as i32 + 1,
        None => 0,
    })
}
