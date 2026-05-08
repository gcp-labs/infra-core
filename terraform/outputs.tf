output "artifact_registry_repository" {
  description = "Artifact Registry repository path for Docker images"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.app_repo.repository_id}"
}