use shadertoy_wgpu::Error;
use std::cell::RefCell;
use std::os::raw::c_char;
use std::ptr;
use std::slice;

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

/// Fills passed buffer with an error message.
///
/// Buffer length can be get with [shadertoy_renderer_last_error_length](fn.shadertoy_renderer_last_error_length.html) function.
///
/// # Returns
///
/// Returns `-1` is passed buffer is `NULL` or too small for error message.
/// Returns `0` if there was no error previously.
///
/// In all other cases returns error message length.
#[no_mangle]
pub unsafe extern "C" fn battery_last_error_message(buffer: *mut c_char, length: i32) -> i32 {
    if buffer.is_null() {
        return -1;
    }

    let last_error = match take_last_error() {
        Some(err) => err,
        None => return 0,
    };

    let error_message = last_error.to_string();

    let buffer = slice::from_raw_parts_mut(buffer as *mut u8, length as usize);

    if error_message.len() >= buffer.len() {
        return -1;
    }

    ptr::copy_nonoverlapping(
        error_message.as_ptr(),
        buffer.as_mut_ptr(),
        error_message.len(),
    );

    buffer[error_message.len()] = b'\0';

    error_message.len() as i32
}
