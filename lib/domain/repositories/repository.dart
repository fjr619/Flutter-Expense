abstract class Repository<T> {
  Future<void> createObject(T collection);

  Future<void> createMultipleObjects(List<T> collections);

  Future<T?> getObjectById(int id);

  Future<List<T?>> getObjectsById(List<int> ids);

  Stream<List<T>> getAllObjects();

  Future<void> updateObject(T collection);

  Future<void> deletObject(T collection);

  Future<void> deleteMultipleObjects(List<int> ids);
}
