// Prints "1" when any video capture device is in use by any process, "0" otherwise.
import CoreMediaIO

func address(_ selector: Int) -> CMIOObjectPropertyAddress {
  CMIOObjectPropertyAddress(
    mSelector: CMIOObjectPropertySelector(selector),
    mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
    mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMain))
}

func deviceIDs() -> [CMIOObjectID] {
  var addr = address(kCMIOHardwarePropertyDevices)
  var size: UInt32 = 0
  guard CMIOObjectGetPropertyDataSize(CMIOObjectID(kCMIOObjectSystemObject), &addr, 0, nil, &size) == 0 else { return [] }
  var ids = [CMIOObjectID](repeating: 0, count: Int(size) / MemoryLayout<CMIOObjectID>.size)
  var used: UInt32 = 0
  guard CMIOObjectGetPropertyData(CMIOObjectID(kCMIOObjectSystemObject), &addr, 0, nil, size, &used, &ids) == 0 else { return [] }
  return ids
}

func isRunningSomewhere(_ id: CMIOObjectID) -> Bool {
  var addr = address(kCMIODevicePropertyDeviceIsRunningSomewhere)
  var running: UInt32 = 0
  var used: UInt32 = 0
  guard CMIOObjectGetPropertyData(id, &addr, 0, nil, UInt32(MemoryLayout<UInt32>.size), &used, &running) == 0 else { return false }
  return running != 0
}

print(deviceIDs().contains(where: isRunningSomewhere) ? "1" : "0")
