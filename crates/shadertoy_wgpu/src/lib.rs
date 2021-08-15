use std::ffi::CStr;
use std::os::raw::c_char;

fn get_msg(ptr: *const c_char) -> String {
    unsafe { CStr::from_ptr(ptr).to_string_lossy().into_owned() }
}

#[no_mangle]
pub extern "C" fn msg(ptr: *const c_char) {
    let msg = get_msg(ptr);
    println!("Message: {}", msg);
}
